//
//  Defines.swift
//  OnePiece
//
//  Created by jiaxin on 2020/7/17.
//  Copyright © 2020 jiaxin. All rights reserved.
//

import Foundation

//================ HasApply =================
public protocol HasApply {}
extension HasApply {
    @discardableResult
    public func apply(_ closure: (Self)->()) -> Self {
        closure(self)
        return self
    }
}
extension NSObject: HasApply {}
//================ HasApply =================








