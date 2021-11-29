//
//  Date+Utils.swift
//  OnePiece
//
//  Created by tony on 2021/11/29.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import Foundation

extension Date: UtilsCompatible { }
public extension UtilsWrapper where Base == Date {
    var year: Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: self.base)
        return components.year
    }

    var month: Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: self.base)
        return components.month
    }

    var day: Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self.base)
        return components.day
    }

    var hour: Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: self.base)
        return components.hour
    }

    var minute: Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute], from: self.base)
        return components.minute
    }

    var second: Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.second], from: self.base)
        return components.second
    }

    var weekday: String? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: self.base)
        let weekdayArray = [" ", "周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        if let index = components.weekday {
            return weekdayArray[index]
        }
        return nil
    }

    var yesterday: Date {
        return self.base.addingTimeInterval(-24 * 60 * 60)
    }

    func lastSomeDay(_ days: Int) -> Date {
        return self.base.addingTimeInterval(-24 * 60 * 60 * TimeInterval(days))
    }

    var tomorrow: Date {
        return self.base.addingTimeInterval(24 * 60 * 60)
    }
    
    func nextSomeDay(_ days: Int) -> Date {
        return self.base.addingTimeInterval(24 * 60 * 60 * TimeInterval(days))
    }

    func isSameDay(with date: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self.base)
        let componentsOther = calendar.dateComponents([.year, .month, .day], from: date)
        if components.year == componentsOther.year && components.month == componentsOther.month && components.day == componentsOther.day {
            return true
        }
        return false
    }

    var isYesterday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInYesterday(self.base)
    }
    
    var isToday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(self.base)
    }

    var isTomorrow: Bool {
        let calendar = Calendar.current
        return calendar.isDateInTomorrow(self.base)
    }
}

