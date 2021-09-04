//
//  GifImageView.swift
//  Example
//
//  Created by jiaxin on 2019/12/19.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation
import UIKit
import OnePiece

class GifImageView: UIView, LifecycleObserver {
    func willAppear() {
        print(#function)
    }

    func didAppear() {
        print(#function)
    }

    func willDisappear() {
        print(#function)
    }

    func didDisappear() {
        print(#function)
    }

    func willDestroy() {
        print(#function)
    }
}
