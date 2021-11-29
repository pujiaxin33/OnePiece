//
//  Data+Utils.swift
//  OnePiece
//
//  Created by tony on 2021/11/29.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import Foundation
import CommonCrypto

extension NSData: UtilsCompatible { }
public extension UtilsWrapper where Base == NSData {
    var hexedString: String
    {
        var string = String()
        let unsafePointer = self.base.bytes.assumingMemoryBound(to: UInt8.self)
        for i in UnsafeBufferPointer<UInt8>(start:unsafePointer, count: self.base.length)
        {
            string += Int(i).utils.hexedString
        }
        return string
    }
    var MD5Data: NSData
    {
        let result = NSMutableData(length: Int(CC_MD5_DIGEST_LENGTH))!
        let unsafePointer = result.mutableBytes.assumingMemoryBound(to: UInt8.self)
        CC_MD5(self.base.bytes, CC_LONG(self.base.length), UnsafeMutablePointer<UInt8>(unsafePointer))
        return NSData(data: result as Data)
    }
    var MD5String: String {
        return self.MD5Data.utils.hexedString
    }
}
