//
//  AssociatedObject.swift
//  OnePiece
//
//  Created by jiaxin on 2019/12/18.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

public struct AssociatedObjectKey {
}

public extension NSObject {
    func associatedObject<T: Any>(key: UnsafeRawPointer) -> T? {
        return objc_getAssociatedObject(self, key) as? T
    }
    func associatedObject<T: Any>(key: UnsafeRawPointer, initial: () -> (T, objc_AssociationPolicy)) -> T {
        var value = objc_getAssociatedObject(self, key) as? T
        if value == nil {
            let initialValue = initial()
            value = initialValue.0
            setAssociatedObject(key: key, value: value, plicy: initialValue.1)
        }
        return value!
    }
    func setAssociatedObject(key: UnsafeRawPointer, value: Any?, plicy: objc_AssociationPolicy) {
        objc_setAssociatedObject(self, key, value, plicy)
    }
}
