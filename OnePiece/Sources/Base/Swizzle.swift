//
//  Swizzle.swift
//  OnePiece
//
//  Created by jiaxin on 2019/12/18.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

@discardableResult
public func swizzleInstanceMethod(target: Any?, originalSelector: Selector, newSelector: Selector) -> Bool {
    let targetClass: AnyClass? = object_getClass(target)
    guard let originalMethod = class_getInstanceMethod(targetClass, originalSelector), let newMethod = class_getInstanceMethod(targetClass, newSelector) else {
        return false
    }
    let didAdd = class_addMethod(targetClass, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))
    if didAdd {
        class_replaceMethod(targetClass, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    }else {
        method_exchangeImplementations(originalMethod, newMethod)
    }
    return true
}

@discardableResult
public func swizzleClassMethod(target: Any?, originalSelector: Selector, newSelector: Selector) -> Bool {
    let targetClass: AnyClass? = object_getClass(target)
    guard let originalMethod = class_getClassMethod(targetClass, originalSelector), let newMethod = class_getClassMethod(targetClass, newSelector) else {
        return false
    }
    let metaClass: AnyClass? = object_getClass(targetClass)
    let didAdd = class_addMethod(metaClass, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))
    if didAdd {
        class_replaceMethod(metaClass, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    }else {
        method_exchangeImplementations(originalMethod, newMethod)
    }
    return true
}
