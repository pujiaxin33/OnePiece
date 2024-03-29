//
//  TitleImageButton.swift
//  OnePiece
//
//  Created by tony on 2021/11/29.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import UIKit

open class TitleImageButton: UIButton {
    open var spacing: CGFloat = 0
    open var imagePosition: ImagePosition = .left

    public enum ImagePosition: Int {
        case top
        case left
        case bottom
        case right
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel?.sizeToFit()
        let imageWidth = image(for: state)?.size.width ?? 0
        let imageHeight = image(for: state)?.size.height ?? 0
        let titleWidth = titleLabel?.intrinsicContentSize.width ?? 0
        let titleHeight = titleLabel?.intrinsicContentSize.height ?? 0

        switch imagePosition {
        case .top:
            let originImageMarginLeft = (self.bounds.size.width - titleWidth - imageWidth)/2
            let newImageMarginLeft = (self.bounds.size.width - imageWidth)/2
            let imageEdgeInsetLeft = newImageMarginLeft - originImageMarginLeft
            imageEdgeInsets = UIEdgeInsets(top: -(titleHeight + spacing)/2, left: imageEdgeInsetLeft, bottom: (titleHeight + spacing)/2, right: -imageEdgeInsetLeft)

            let originTitleMarginLeft = originImageMarginLeft + imageWidth
            let newTitleMarginLeft = (self.bounds.size.width - titleWidth)/2
            let titleEdgeInsetLeft = newTitleMarginLeft - originTitleMarginLeft
            titleEdgeInsets = UIEdgeInsets(top: (imageHeight + spacing)/2, left: titleEdgeInsetLeft, bottom: -(imageHeight + spacing)/2, right: -titleEdgeInsetLeft)
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing/2, bottom: 0, right: spacing/2)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: -spacing/2)
        case .bottom:
            let originImageMarginLeft = (self.bounds.size.width - titleWidth - imageWidth)/2
            let newImageMarginLeft = (self.bounds.size.width - imageWidth)/2
            let imageEdgeInsetLeft = newImageMarginLeft - originImageMarginLeft
            imageEdgeInsets = UIEdgeInsets(top: (titleHeight + spacing)/2, left: imageEdgeInsetLeft, bottom: -(titleHeight + spacing)/2, right: -imageEdgeInsetLeft)

            let originTitleMarginLeft = originImageMarginLeft + imageWidth
            let newTitleMarginLeft = (self.bounds.size.width - titleWidth)/2
            let titleEdgeInsetLeft = newTitleMarginLeft - originTitleMarginLeft
            titleEdgeInsets = UIEdgeInsets(top: -(imageHeight + spacing)/2, left: titleEdgeInsetLeft, bottom:(imageHeight + spacing)/2, right: -titleEdgeInsetLeft)
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: titleWidth + spacing, bottom: 0, right: -(titleWidth + spacing))
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageWidth + spacing), bottom: 0, right: imageWidth + spacing)
        }
    }
}
