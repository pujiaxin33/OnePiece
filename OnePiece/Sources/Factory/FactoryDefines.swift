//
//  FactoryDefines.swift
//  OnePiece
//
//  Created by tony on 2021/11/29.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    public class func from(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        return .systemFont(ofSize: size, weight: weight)
    }
}

extension UIColor {
    public class func fromHex(_ hex: Int, _ alpha: CGFloat = 1) -> UIColor {
        return UIColor.fromRGBA((CGFloat((hex & 0xFF0000) >> 16)), (CGFloat((hex & 0xFF00) >> 8)), (CGFloat(hex & 0xFF)), alpha)
    }
    public class func fromRGBA(_ red: CGFloat,_  green: CGFloat,_ blue: CGFloat, _ alpha: CGFloat = 1) -> UIColor {
        return UIColor.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
}

extension UIImage {
    public class func fromColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 10, height: 10), false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        color.set()
        context!.fill(CGRect.init(x: 0, y: 0, width: 10, height: 10))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image!
    }
}
