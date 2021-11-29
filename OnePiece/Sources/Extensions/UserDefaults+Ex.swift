//
//  UserDefaults.swift
//  OnePiece
//
//  Created by jiaxin on 2019/12/18.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

//将UserDefaults key硬编码集中到UserDefaultsKey结构体里面
public struct UserDefaultsKey {
    static let example: String = "com.one.piece.uak.example.key"
}

//提供默认值的封装
public extension UserDefaults {
    func string(forKey defaultName: String, defaultValue: @autoclosure () -> String) -> String {
        if let value = string(forKey: defaultName) {
            return value
        }else {
            let value = defaultValue()
            set(value, forKey: defaultName)
            return value
        }
    }
    func array(forKey defaultName: String, defaultValue: @autoclosure () -> [Any]) -> [Any] {
        if let value = array(forKey: defaultName) {
            return value
        }else {
            let value = defaultValue()
            set(value, forKey: defaultName)
            return value
        }
    }
    func dictionary(forKey defaultName: String, defaultValue: @autoclosure () -> [String : Any]) -> [String : Any] {
        if let value = dictionary(forKey: defaultName) {
            return value
        }else {
            let value = defaultValue()
            set(value, forKey: defaultName)
            return value
        }
    }
    func data(forKey defaultName: String, defaultValue: @autoclosure () -> Data) -> Data {
        if let value = data(forKey: defaultName) {
            return value
        }else {
            let value = defaultValue()
            set(value, forKey: defaultName)
            return value
        }
    }
    func stringArray(forKey defaultName: String, defaultValue: @autoclosure () -> [String]) -> [String] {
        if let value = stringArray(forKey: defaultName) {
            return value
        }else {
            let value = defaultValue()
            set(value, forKey: defaultName)
            return value
        }
    }
    func integer(forKey defaultName: String, defaultValue: @autoclosure () -> Int) -> Int {
        if object(forKey: defaultName) != nil {
            return integer(forKey: defaultName)
        }else {
            let value = defaultValue()
            set(value, forKey: defaultName)
            return value
        }
    }
    func float(forKey defaultName: String, defaultValue: @autoclosure () -> Float) -> Float {
        if object(forKey: defaultName) != nil {
            return float(forKey: defaultName)
        }else {
            let value = defaultValue()
            set(value, forKey: defaultName)
            return value
        }
    }
    func double(forKey defaultName: String, defaultValue: @autoclosure () -> Double) -> Double {
        if object(forKey: defaultName) != nil {
            return double(forKey: defaultName)
        }else {
            let value = defaultValue()
            set(value, forKey: defaultName)
            return value
        }
    }
    func bool(forKey defaultName: String, defaultValue: @autoclosure () -> Bool) -> Bool {
        if object(forKey: defaultName) != nil {
            return bool(forKey: defaultName)
        }else {
            let value = defaultValue()
            set(value, forKey: defaultName)
            return value
        }
    }
    func url(forKey defaultName: String, defaultValue: @autoclosure () -> URL) -> URL {
        if let value = url(forKey: defaultName) {
            return value
        }else {
            let value = defaultValue()
            set(value, forKey: defaultName)
            return value
        }
    }
}
