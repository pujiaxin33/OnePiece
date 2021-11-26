//
//  Line.swift
//  OnePiece
//
//  Created by jiaxin on 2020/7/16.
//  Copyright © 2020 jiaxin. All rights reserved.
//

import Foundation
import UIKit

public protocol Lineable { }
extension Lineable {
    public var line: LineWrapper<Self> { return LineWrapper(base: self) }
}
public struct LineWrapper<Base> {
    let base: Base
    public init(base: Base) {
        self.base = base
    }
}
public extension LineWrapper where Base: UIView {
    var topLine: UIView? { return base.topLine }
    var bottomLine: UIView? { return base.bottomLine }
    var leftLine: UIView? { return base.leftLine }
    var rightLine: UIView? { return base.rightLine }
    
    func addTop(lineWidth: CGFloat = 1/UIScreen.main.scale, insets: UIEdgeInsets = .zero, lineColor: UIColor = UIColor.lightGray) {
        removeTop()
        base.topLine = UIView()
        base.topLine?.backgroundColor = lineColor
        base.addSubview(base.topLine!)
        base.topLine?.translatesAutoresizingMaskIntoConstraints = false
        base.topLine?.topAnchor.constraint(equalTo: base.topAnchor, constant: insets.top).isActive = true
        base.topLine?.leadingAnchor.constraint(equalTo: base.leadingAnchor, constant: insets.left).isActive = true
        base.topLine?.trailingAnchor.constraint(equalTo: base.trailingAnchor, constant: -insets.right).isActive = true
        base.topLine?.heightAnchor.constraint(equalToConstant: lineWidth).isActive = true
    }
    func addBottom(lineWidth: CGFloat = 1/UIScreen.main.scale, insets: UIEdgeInsets = .zero, lineColor: UIColor = UIColor.lightGray) {
        removeBottom()
        base.bottomLine = UIView()
        base.bottomLine?.backgroundColor = lineColor
        base.addSubview(base.bottomLine!)
        base.bottomLine?.translatesAutoresizingMaskIntoConstraints = false
        base.bottomLine?.bottomAnchor.constraint(equalTo: base.bottomAnchor, constant: -insets.bottom).isActive = true
        base.bottomLine?.leadingAnchor.constraint(equalTo: base.leadingAnchor, constant: insets.left).isActive = true
        base.bottomLine?.trailingAnchor.constraint(equalTo: base.trailingAnchor, constant: -insets.right).isActive = true
        base.bottomLine?.heightAnchor.constraint(equalToConstant: lineWidth).isActive = true
    }
    func addLeading(lineWidth: CGFloat = 1/UIScreen.main.scale, insets: UIEdgeInsets = .zero, lineColor: UIColor = UIColor.lightGray) {
        removeLeading()
        base.leftLine = UIView()
        base.leftLine?.backgroundColor = lineColor
        base.addSubview(base.leftLine!)
        base.leftLine?.translatesAutoresizingMaskIntoConstraints = false
        base.leftLine?.topAnchor.constraint(equalTo: base.topAnchor, constant: insets.top).isActive = true
        base.leftLine?.leadingAnchor.constraint(equalTo: base.leadingAnchor, constant: insets.left).isActive = true
        base.leftLine?.bottomAnchor.constraint(equalTo: base.bottomAnchor, constant: -insets.bottom).isActive = true
        base.leftLine?.widthAnchor.constraint(equalToConstant: lineWidth).isActive = true
    }
    func addTrailinng(lineWidth: CGFloat = 1/UIScreen.main.scale, insets: UIEdgeInsets = .zero, lineColor: UIColor = UIColor.lightGray) {
        removeTrailing()
        base.rightLine = UIView()
        base.rightLine?.backgroundColor = lineColor
        base.addSubview(base.rightLine!)
        base.rightLine?.translatesAutoresizingMaskIntoConstraints = false
        base.rightLine?.topAnchor.constraint(equalTo: base.topAnchor, constant: insets.top).isActive = true
        base.rightLine?.trailingAnchor.constraint(equalTo: base.trailingAnchor, constant: -insets.right).isActive = true
        base.rightLine?.bottomAnchor.constraint(equalTo: base.bottomAnchor, constant: -insets.bottom).isActive = true
        base.rightLine?.widthAnchor.constraint(equalToConstant: lineWidth).isActive = true
    }
    func removeAll() {
        removeTop()
        removeBottom()
        removeLeading()
        removeTrailing()
    }
    func removeTop() {
        base.topLine?.removeFromSuperview()
        base.topLine = nil
    }
    func removeBottom() {
        base.bottomLine?.removeFromSuperview()
        base.bottomLine = nil
    }
    func removeLeading() {
        base.leftLine?.removeFromSuperview()
        base.leftLine = nil
    }
    func removeTrailing() {
        base.rightLine?.removeFromSuperview()
        base.rightLine = nil
    }
}
struct LineAssociatedKeys {
    static var topLine: UInt8 = 0
    static var leadingLine: UInt8 = 0
    static var trailingLine: UInt8 = 0
    static var bottomLine: UInt8 = 0
}
extension UIView {
    fileprivate var topLine: UIView? {
        set { objc_setAssociatedObject(self, &LineAssociatedKeys.topLine, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
        get { return objc_getAssociatedObject(self, &LineAssociatedKeys.topLine) as? UIView }
    }
    fileprivate var bottomLine: UIView? {
        set { objc_setAssociatedObject(self, &LineAssociatedKeys.bottomLine, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
        get { return objc_getAssociatedObject(self, &LineAssociatedKeys.bottomLine) as? UIView }
    }
    fileprivate var leftLine: UIView? {
        set { objc_setAssociatedObject(self, &LineAssociatedKeys.leadingLine, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
        get { return objc_getAssociatedObject(self, &LineAssociatedKeys.leadingLine) as? UIView }
    }
    fileprivate var rightLine: UIView? {
        set { objc_setAssociatedObject(self, &LineAssociatedKeys.trailingLine, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
        get { return objc_getAssociatedObject(self, &LineAssociatedKeys.trailingLine) as? UIView }
    }
}
extension UIView: Lineable {}