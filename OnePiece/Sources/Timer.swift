//
//  Timer.swift
//  OnePiece
//
//  Created by jiaxin on 2019/12/18.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

/// Timer优化方案一：extension扩展
/// 通过block接受外部的回调处理逻辑。这样就可以避免target-action的方式，导致timer强引用target。
/// 将timer生命周期有效范围内的owner传递进来，比如UIViewController内部初始化的timer，lifecycleOwner就是UIViewController。并对lifecycleOwner进行弱引用，在timer回调的地方再检测lifecycleOwner是否已经被释放了。如果lifecycleOwner为nil，表示已经被释放，把当前timer调用invalidate给注销掉。达到及时让timer失效的目的。
public extension Timer {
    convenience init(lifecycleOwner: AnyObject, timeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) {
        let proxy = ExtensionTimerWeakProxy(block: block)
        self.init(timeInterval: interval, target: proxy, selector: #selector(SafeTimerWeakProxy.callback), userInfo: nil, repeats: repeats)
        proxy.timer = self
        proxy.lifecycleOwner = lifecycleOwner
    }

    convenience init(lifecycleOwner: AnyObject, fire date: Date, interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) {
        let proxy = ExtensionTimerWeakProxy(block: block)
        self.init(timeInterval: interval, target: proxy, selector: #selector(SafeTimerWeakProxy.callback), userInfo: nil, repeats: repeats)
        self.fireDate = date
        proxy.timer = self
        proxy.lifecycleOwner = lifecycleOwner
    }

    @discardableResult
    class func scheduledTimer(withLifecycleOwner lifecycleOwner: AnyObject, interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> Timer {
        let proxy = ExtensionTimerWeakProxy(block: block)
        let timer = Timer.scheduledTimer(timeInterval: interval, target: proxy, selector: #selector(ExtensionTimerWeakProxy.callback), userInfo: nil, repeats: repeats)
        proxy.timer = timer
        proxy.lifecycleOwner = lifecycleOwner
        return timer
    }
}

class ExtensionTimerWeakProxy: NSObject {
    let block: ((Timer) -> Void)
    var timer: Timer?
    weak var lifecycleOwner: AnyObject?

    init(block: @escaping ((Timer) -> Void)) {
        self.block = block
    }

    @objc func callback() {
        guard let timer = timer else {
            return
        }
        if lifecycleOwner == nil {
            timer.invalidate()
            self.timer = nil
        }else {
            block(timer)
        }
    }
}

/// Timer优化方案二：SafeTimerScheduler封装
/// 通过SafeTimerScheduler的示例创建Timer的实例，类似于工厂方法。
/// 通过block接受外部的回调处理逻辑。这样就可以避免target-action的方式，导致timer强引用target。
/// 需要外部lifecycleOwner用实例引用SafeTimerScheduler实例，当SafeTimerScheduler实例的deinit方法调用时，也就是lifecycleOwner即将销毁的时候。这时SafeTimerScheduler将内部记录的timer，调用invalidate注销掉，达到及时让timer失效的目的。
public class SafeTimerScheduler {
    var timers = [Timer]()

    deinit {
        timers.forEach { $0.invalidate() }
        timers.removeAll()
    }
    public init() {}

    @discardableResult
    public func makeTimer(timeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> Timer {
        let proxy = SafeTimerWeakProxy(block: block)
        let timer = Timer(timeInterval: interval, target: proxy, selector: #selector(SafeTimerWeakProxy.callback), userInfo: nil, repeats: repeats)
        proxy.timer = timer
        timers.append(timer)
        return timer
    }

    @discardableResult
    public func makeTimer(fire date: Date, interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> Timer {
        let proxy = SafeTimerWeakProxy(block: block)
        let timer = Timer(timeInterval: interval, target: proxy, selector: #selector(SafeTimerWeakProxy.callback), userInfo: nil, repeats: repeats)
        proxy.timer = timer
        timer.fireDate = date
        timers.append(timer)
        return timer
    }

    @discardableResult
    public func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> Timer {
        let proxy = SafeTimerWeakProxy(block: block)
        let timer = Timer.scheduledTimer(timeInterval: interval, target: proxy, selector: #selector(SafeTimerWeakProxy.callback), userInfo: nil, repeats: repeats)
        proxy.timer = timer
        timers.append(timer)
        return timer
    }
}

class SafeTimerWeakProxy: NSObject {
    let block: ((Timer) -> Void)
    var timer: Timer?

    init(block: @escaping ((Timer) -> Void)) {
        self.block = block
    }

    @objc func callback() {
        guard let timer = timer else {
            return
        }
        block(timer)
    }
}
