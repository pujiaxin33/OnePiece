//
//  Image.swift
//  OnePiece
//
//  Created by jiaxin on 2019/12/20.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    class func imageWithColor(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 10, height: 10), false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        color.set()
        context!.fill(CGRect.init(x: 0, y: 0, width: 10, height: 10))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image!
    }
}
