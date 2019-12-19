//
//  LifeView.swift
//  Example
//
//  Created by jiaxin on 2019/12/19.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import OnePiece

class LifeView: UIView, LifecycleOwner {

    override init(frame: CGRect) {
        super.init(frame: frame)

        let view = GifImageView()
        addSubview(view)
        addLifecycleObserver(view)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
