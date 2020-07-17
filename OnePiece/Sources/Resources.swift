//
//  Resources.swift
//  OnePiece
//
//  Created by jiaxin on 2020/7/17.
//  Copyright © 2020 jiaxin. All rights reserved.
//

import Foundation
import UIKit

public typealias ColorResource = Resource.Color
public typealias TextResource = Resource.Text
public typealias DimensionResource = Resource.Dimension
public typealias NumberResource = Resource.Number
public typealias GlobalResource = Resource.Global

public struct Resource {
    public struct Color {
        /// UIColor.white
        public static let contentBackground = UIColor.white
    }

    public struct Text {
        public static let networkInvalid = "服务器开小差了，待会儿再试吧"
    }

    public struct Dimension {
        public static let lineWidth: CGFloat = 1.0 / UIScreen.main.scale
        public static let margin: CGFloat = 12
    }

    public struct Number {
        public static let pageSize: Int = 50
    }

    public struct Global {
        public static let appScheme: String = "test"
    }
}
