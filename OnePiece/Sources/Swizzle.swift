//
//  Swizzle.swift
//  OnePiece
//
//  Created by jiaxin on 2019/12/18.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

/*
public class SwizzleMethodExecutor {
    public func execute() {
        UIView.executeSwizzleMethod
    }
}
extension UIView {
    static let executeSwizzleMethod: Void = {
        swizzleInstanceMethod(target: UIView(), originalSelector: #selector(addSubview(_:)), newSelector: #selector(swizzledAddSubview(_:)))
        swizzleClassMethod(target: UIView(), originalSelector: #selector(setAnimationsEnabled(_:)), newSelector: #selector(swizzledSetAnimationsEnabled(_:)))
    }()
    @objc private func swizzledAddSubview(_ view: UIView) {
        swizzledAddSubview(view)
        let label = UILabel()
        swizzledAddSubview(label)
    }
    @objc private class func swizzledSetAnimationsEnabled(_ enabled: Bool) {
        swizzledSetAnimationsEnabled(true)
    }
}
*/

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
