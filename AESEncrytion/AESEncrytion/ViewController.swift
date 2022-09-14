//
//  ViewController.swift
//  AESEncrytion
//
//  Created by Sejal Khanna on 06/06/22.
//

import UIKit
import CryptoKit
import CommonCrypto

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let message = "phrhniTZAZ/5CZ1flf+T4yQrTqlTsYZWUP5Cre17Q+ocAercHJeu+0jxft7uACnMuLW2wI4ZRzqHbrJ50voHQ0I2hHFATivGQ0B30jwGanMVTPHYhu+ARtvnxF6rP1JvNS7cBP6+SBXu84A/9EunNXMh8tiJIRnrzpLATCXJrBo"
        let data1 = message.data(using: .utf8)!.base64EncodedData()

        let a = Array(data1)
        print(a.count)
        let array: [Int8] = data1.map{Int8(bitPattern: $0)}
        print(array)
        let keyData     = "ORUJUDO0UTMf0RS0tQTEMkMxBTkNETN0".data(using:String.Encoding.utf8)!
        let ivData      = "kzTgNGjktQL1VUzN".data(using:String.Encoding.utf8)!

        let decryptedData = testCrypt(data:data1, keyData:keyData, ivData:ivData, operation: kCCDecrypt)

        var decr = decryptedData.base64EncodedString()
        let data = Data(base64Encoded: decr)
        print(decr)
        print(String(data: data!, encoding: .utf8))
    }
    
    func testCrypt(data:Data, keyData:Data, ivData:Data, operation:Int) -> Data {
        let cryptLength  = size_t(data.count + kCCBlockSizeAES128)
        var cryptData = Data(count:cryptLength)

        let keyLength             = size_t(kCCKeySizeAES256)
        let options   = CCOptions(kCCOptionECBMode)

        var numBytesEncrypted :size_t = 0

        let cryptStatus = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes {dataBytes in
                ivData.withUnsafeBytes {ivBytes in
                    keyData.withUnsafeBytes {keyBytes in
                        CCCrypt(CCOperation(operation),
                                  CCAlgorithm(kCCAlgorithmAES),
                                  options,
                                  keyBytes, keyLength,
                                  ivBytes,
                                  dataBytes, data.count,
                                  cryptBytes, cryptLength,
                                  &numBytesEncrypted)
                    }
                }
            }
        }
        cryptData.removeSubrange(numBytesEncrypted..<cryptData.count)
//        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
//
//
//        } else {
//            print("Error: \(cryptStatus)")
//        }

        return cryptData;
    }

}
