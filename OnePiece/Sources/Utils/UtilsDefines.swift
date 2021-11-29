//
//  UtilsDefines.swift
//  OnePiece
//
//  Created by tony on 2021/11/29.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import Foundation

public protocol UtilsCompatible { }
public extension UtilsCompatible {
    var utils: UtilsWrapper<Self> {
        get { UtilsWrapper(self) }
        set { }
    }
}
public struct UtilsWrapper<Base> {
    let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}
