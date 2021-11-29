//
//  Int+Utils.swift
//  OnePiece
//
//  Created by tony on 2021/11/29.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import Foundation

extension Int: UtilsCompatible { }
public extension UtilsWrapper where Base == Int {
    var hexedString: String {
        return String(format: "%02x", self.base)
    }
}
