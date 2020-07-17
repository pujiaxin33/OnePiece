//
//  Compatible.swift
//  OnePiece
//
//  Created by jiaxin on 2020/7/17.
//  Copyright © 2020 jiaxin. All rights reserved.
//

import Foundation
import UIKit

public func compatibleHeight(_ standardWidth: CGFloat, _ standardHeight: CGFloat) -> CGFloat {
    return UIScreen.main.bounds.size.width*standardHeight/standardWidth
}

