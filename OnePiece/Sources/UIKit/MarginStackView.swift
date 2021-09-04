//
//  MarginStackView.swift
//  OnePiece
//
//  Created by tony on 2021/9/4.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import UIKit

open class MarginStackView: UIStackView {
    public struct Margin: Equatable {
        public var top: CGFloat = 0
        public var bottom: CGFloat = 0
        public var left: CGFloat = 0
        public var right: CGFloat = 0
        public static let zero = Margin.init()
        public init(top: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0) {
            self.top = top
            self.bottom = bottom
            self.left = left
            self.right = right
        }
        public static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.top == rhs.top && lhs.bottom == rhs.bottom && lhs.left == rhs.left && lhs.right == rhs.right
        }
    }
    
    open func addArrangedSubview(_ view: UIView, with margin: Margin) {
        if margin == .zero {
            super.addArrangedSubview(view)
        }else {
            let container = contianerView(view, with: margin)
            super.addArrangedSubview(container)
        }
    }
    
    open func insertArrangedSubview(_ view: UIView, at stackIndex: Int, with margin: Margin) {
        if margin == .zero {
            super.insertArrangedSubview(view, at: stackIndex)
        }else {
            let container = contianerView(view, with: margin)
            super.insertArrangedSubview(container, at: stackIndex)
        }
    }
    
    open override func removeArrangedSubview(_ view: UIView) {
        if let container = view.superview as? MarginContainerView {
            super.removeArrangedSubview(container)
        }else {
            super.removeArrangedSubview(view)
        }
    }

    func contianerView(_ view: UIView, with margin: Margin) -> MarginContainerView {
        let container = MarginContainerView()
        container.backgroundColor = .clear
        container.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: container.topAnchor, constant: margin.top).isActive = true
        view.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -margin.bottom).isActive = true
        view.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: margin.left).isActive = true
        view.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -margin.right).isActive = true
        return container
    }
}

class MarginContainerView: UIView {
    override func willRemoveSubview(_ subview: UIView) {
        if superview != nil {
            removeFromSuperview()
        }
    }
}
