//
//  String+Utils.swift
//  OnePiece
//
//  Created by tony on 2021/11/29.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import Foundation

extension String: UtilsCompatible { }

public extension UtilsWrapper where Base == String {
    var urlParameters: [String: Any]? {
        guard let urlComponents = NSURLComponents(string: self.base), let queryItems = urlComponents.queryItems else {
            return nil
        }
        var parameters = [String: Any]()
        queryItems.forEach({ (item) in
            if let existValue = parameters[item.name], let value = item.value {
                if var existValue = existValue as? [Any] {
                    existValue.append(value)
                } else {
                    parameters[item.name] = [existValue, value]
                }
            } else {
                parameters[item.name] = item.value
            }
        })
        return parameters
    }
    
    var md5: String {
        let data = (self.base as NSString).data(using: String.Encoding.utf8.rawValue)! as NSData
        return data.utils.MD5String
    }
    
    var firstUppercasedLetter: String {
        let stringRef = NSMutableString(string: self.base) as CFMutableString
        CFStringTransform(stringRef,nil, kCFStringTransformToLatin, false);
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false);
        var pinyin = stringRef as String;
        pinyin = pinyin.replacingOccurrences(of: " ", with: "")
        pinyin = pinyin.uppercased()
        return String(pinyin.first ?? "A")
    }
    
    //6-20位不全是字母或不全是数字的任意字符
    var isValidPassword: Bool {
        return self.base.utils.validate(value: "^(?![0-9]+$)(?![a-zA-Z]+$)[\\s\\S]{6,16}$")
    }
    
    var isValidEmail: Bool {
        return self.base.utils.validate(value: "^[a-zA-Z0-9\\_\\-\\.]{2,}[@][a-zA-Z0-9\\_\\-]+([.][a-zA-Z0-9]{2,})+$")
    }

    var isValidNick: Bool {
        return self.base.utils.validate(value: "^[\\w\\-\\_\\u4e00-\\u9fa5]{2,12}$")
    }
    
    func isValidPhoneNumber() -> Bool{
        return self.validate(value: "^\\d{11}$")
    }

    func containsChinese() -> Bool {
        for value in self.base {
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        return false
    }

    func containsEmoji() -> Bool {
        //验证第三方键盘的emoji
        var result = self.validate(value: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]")
        if result == false {
            //验证系统键盘的emoji
            result = self.base.unicodeScalars.contains { $0.isEmoji }
        }
        return result
    }

    func validate(value: String) -> Bool {
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", value)
        return predicate.evaluate(with: self)
    }
}

extension UnicodeScalar {
    var isEmoji: Bool {
        switch value {
        case 0x1F600...0x1F64F, // Emoticons
        0x1F300...0x1F5FF, // Misc Symbols and Pictographs
        0x1F680...0x1F6FF, // Transport and Map
        0x1F1E6...0x1F1FF, // Regional country flags
        0x2600...0x26FF,   // Misc symbols
        0x2700...0x27BF,   // Dingbats
        0xFE00...0xFE0F,   // Variation Selectors
        0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
        127000...127600, // Various asian characters
        65024...65039, // Variation selector
        9100...9300, // Misc items
        8400...8447: // Combining Diacritical Marks for Symbols
            return true
        default: return false
        }
    }
    var isZeroWidthJoiner: Bool {
        return value == 8205
    }
}
