//
//  Lifecycle.swift
//  OnePiece
//
//  Created by jiaxin on 2019/12/19.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation
import UIKit

extension AssociatedObjectKey {
    static var LifecycleOwnerObserversKey: UInt8 = 0
    static var LifecyleDeallocListenerKey: UInt8 = 0
    static var isLifecycleObserverEnabledKey: UInt8 = 0
}

class DeallocListener: NSObject {
    var lifecycleObservers: [LifecycleObserver] {
        set {
            setAssociatedObject(key: &AssociatedObjectKey.LifecycleOwnerObserversKey, value: newValue, plicy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get { associatedObject(key: &AssociatedObjectKey.LifecycleOwnerObserversKey) { return ([LifecycleObserver](), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)} }
    }
    deinit {
        lifecycleObservers.forEach { $0.dealloc() }
    }
}

public protocol LifecycleOwner: class {
    func addLifecycleObserver(_ observer: LifecycleObserver)
}
public protocol LifecycleObserver: class {
    func dealloc()
    func willAppear()
    func didAppear()
    func willDisappear()
    func didDisappear()
}
public extension LifecycleOwner where Self: UIViewController {
    func addLifecycleObserver(_ observer: LifecycleObserver) {
        isLifecycleObserverEnabled = true
        UIViewController.executeSwizzleMethod
        lifecycleObservers.append(observer)
    }
}
extension UIViewController {
    var isLifecycleObserverEnabled: Bool {
        set { setAssociatedObject(key: &AssociatedObjectKey.isLifecycleObserverEnabledKey, value: newValue, plicy: .OBJC_ASSOCIATION_ASSIGN)}
        get { associatedObject(key: &AssociatedObjectKey.isLifecycleObserverEnabledKey) { return (false, .OBJC_ASSOCIATION_ASSIGN)} }
    }
    var lifecycleObservers: [LifecycleObserver] {
        set { deallocListener.lifecycleObservers = newValue }
        get { return deallocListener.lifecycleObservers }
    }
    var deallocListener: DeallocListener {
        set { }
        get { associatedObject(key: &AssociatedObjectKey.LifecyleDeallocListenerKey) { return (DeallocListener(), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) } }
    }
    static let executeSwizzleMethod: Void = {
        let instance = UIViewController()
        swizzleInstanceMethod(target: instance, originalSelector: #selector(viewWillAppear(_:)), newSelector: #selector(swizzledViewWillAppear(_:)))
        swizzleInstanceMethod(target: instance, originalSelector: #selector(viewDidAppear(_:)), newSelector: #selector(swizzledViewDidAppear(_:)))
        swizzleInstanceMethod(target: instance, originalSelector: #selector(viewWillDisappear(_:)), newSelector: #selector(swizzledViewWillDisappear(_:)))
        swizzleInstanceMethod(target: instance, originalSelector: #selector(viewDidDisappear(_:)), newSelector: #selector(swizzledViewDidDisappear(_:)))
    }()
    @objc func swizzledViewWillAppear(_ animated: Bool) {
        swizzledViewWillAppear(animated)
        guard isLifecycleObserverEnabled else {
            return
        }
        lifecycleObservers.forEach { $0.willAppear() }
    }
    @objc func swizzledViewDidAppear(_ animated: Bool) {
        swizzledViewDidAppear(animated)
        guard isLifecycleObserverEnabled else {
            return
        }
        lifecycleObservers.forEach { $0.didAppear() }
    }
    @objc func swizzledViewWillDisappear(_ animated: Bool) {
        swizzledViewWillDisappear(animated)
        guard isLifecycleObserverEnabled else {
            return
        }
        lifecycleObservers.forEach { $0.willDisappear() }
    }
    @objc func swizzledViewDidDisappear(_ animated: Bool) {
        swizzledViewDidDisappear(animated)
        guard isLifecycleObserverEnabled else {
            return
        }
        lifecycleObservers.forEach { $0.didDisappear() }
    }
}

public extension LifecycleOwner where Self: UIView {
    func addLifecycleObserver(_ observer: LifecycleObserver) {
        isLifecycleObserverEnabled = true
        UIView.executeSwizzleMethod
        lifecycleObservers.append(observer)
    }
}
extension UIView {
    var isLifecycleObserverEnabled: Bool {
        set { setAssociatedObject(key: &AssociatedObjectKey.isLifecycleObserverEnabledKey, value: newValue, plicy: .OBJC_ASSOCIATION_ASSIGN)}
        get { associatedObject(key: &AssociatedObjectKey.isLifecycleObserverEnabledKey) { return (false, .OBJC_ASSOCIATION_ASSIGN)} }
    }
    var lifecycleObservers: [LifecycleObserver] {
        set { deallocListener.lifecycleObservers = newValue }
        get { return deallocListener.lifecycleObservers }
    }
    var deallocListener: DeallocListener {
        set { }
        get { associatedObject(key: &AssociatedObjectKey.LifecyleDeallocListenerKey) { return (DeallocListener(), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) } }
    }
    static let executeSwizzleMethod: Void = {
        let instance = UIView()
        swizzleInstanceMethod(target: instance, originalSelector: #selector(willMove(toWindow:)), newSelector: #selector(swizzledWillMove(toWindow:)))
        swizzleInstanceMethod(target: instance, originalSelector: #selector(didMoveToWindow), newSelector: #selector(swizzledDidMoveToWindow))
    }()
    @objc func swizzledWillMove(toWindow newWindow: UIWindow?)  {
        swizzledWillMove(toWindow: newWindow)
        guard isLifecycleObserverEnabled else {
            return
        }
        //情况一：当页面A pop的时候，页面A的view正常调用该方法一次，newWindow=nil，表示视图将要消失
        //情况二：当页面A push 到页面B时，页面A的view会调用三次该方法
        //第一次newWindow=nil，表示视图将要消失
        //第二次newWindow!=nil，表示视图将要显示
        //第三次newWindow=nil，表示视图将要消失
        //所以，最终结果是视图将要消失，但是第一次、第二次纯属多余。所以，如果你的业务视图依赖该生命周期方法，需要明白这个特殊点。
        if newWindow == nil {
            lifecycleObservers.forEach { $0.willDisappear() }
        }else {
            lifecycleObservers.forEach { $0.willAppear() }
        }
    }
    @objc func swizzledDidMoveToWindow() {
        swizzledDidMoveToWindow()
        guard isLifecycleObserverEnabled else {
            return
        }
        //同willMove(toWindow newWindow: UIWindow?)的说明一样
        if window == nil {
            lifecycleObservers.forEach { $0.didDisappear() }
        }else {
            lifecycleObservers.forEach { $0.didAppear() }
        }
    }
}
