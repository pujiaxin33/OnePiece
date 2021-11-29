//
//  UIImage+Utils.swift
//  OnePiece
//
//  Created by tony on 2021/11/29.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import Foundation
import UIKit

extension UIImage: UtilsCompatible { }

public extension UtilsWrapper where Base == UIImage {
    var data: Data? {
        if let data = self.base.pngData() {
            return data
        }else if let data = self.base.jpegData(compressionQuality: 1) {
            return data
        }else {
            return nil
        }
    }
    func compressedData(maxSize: Int = 1024*1024) -> Data? {
        guard var jpgData = self.base.jpegData(compressionQuality: 1) else { return nil }
        if jpgData.count < maxSize {
            return jpgData
        }
        var compress:CGFloat = 0.9
        repeat {
            if let data = self.base.jpegData(compressionQuality: compress) {
                jpgData = data
                compress -= 0.02
            }else {
                break
            }
        }while jpgData.count > maxSize && compress > 0.01
        return jpgData
    }
}
