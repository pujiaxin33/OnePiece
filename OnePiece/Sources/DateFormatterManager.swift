//
//  DateFormatterManager.swift
//  OnePiece
//
//  Created by jiaxin on 2019/12/20.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

enum DateFormat: String {
    case yyyy_MM_dd = "yyyy-MM-dd"
    case yyyy_MM_dd_HH_mm = "yyyy-MM-dd HH:mm"
    case yyyy_MM_dd_HH_mm_ss = "yyyy-MM-dd HH:mm:ss"
    case yyyy_MM_dd_HH_mm_ss_SSS = "yyyy-MM-dd HH:mm:ss SSS"
}

class DateFormatterManager {
    private static var cache = NSCache<NSString, DateFormatter>()

    static func dateFormatter(for dateFormat: DateFormat) -> DateFormatter {
        return dateFormatter(for: dateFormat.rawValue)
    }

    static func dateFormatter(for dateFormat: String) -> DateFormatter {
        if let dateFormatter = cache.object(forKey: NSString(string: dateFormat)) {
            return dateFormatter
        }else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            cache.setObject(dateFormatter, forKey: NSString(string: dateFormat))
            return dateFormatter
        }
    }
}
