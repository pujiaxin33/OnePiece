//
//  DelayManager.swift
//  OnePiece
//
//  Created by jiaxin on 2019/12/23.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

/// 延迟指定时间再去执行任务
/// 中间可以取消之前的延迟执行的任务
/// 适用场景：某个任务创建和销毁比较消耗性能、内存。但是需要点击某个item才需要创建，点击另一个item需要销毁。但是用户有可能会频繁点击，导致频繁创建销毁，可能会出现未知问题。所以，该场景可以通过延迟销毁任务来避免。
/// 从A切换到B，延迟销毁A的某个任务。快速从B切换到A，取消之前A的销毁任务，中间就没有真正执行销毁任务，当前的A任务还处于执行状态。
public class DelayManager {
    static let shared = DelayManager()
    private var taskDict = [String: DelayTask]()

    public func registerTask(taskID: String, delay: TimeInterval, taskBlock: @escaping ()->()) {
        let task = DelayTask(taskID: taskID, delay: delay, taskBlock: taskBlock)
        task.didExecutedCallback = {[weak self] in
            self?.taskDict.removeValue(forKey: taskID)
        }
        task.start()
        taskDict[taskID] = task
    }

    public func unregisterTask(taskID: String) -> DelayTask? {
        let task = taskDict[taskID]
        if task != nil {
            task?.cancel()
            self.taskDict.removeValue(forKey: taskID)
        }
        return task
    }

    public func unregisterAllTasks() {
        taskDict.values.forEach { $0.cancel() }
        taskDict.removeAll()
    }

    public func executeTask(with taskID: String) {
        for (id, task) in taskDict {
            if id == taskID {
                task.execute()
                taskDict.removeValue(forKey: id)
                break
            }
        }
    }

    public func executeAllTasksImmediately() {
        taskDict.values.forEach { $0.execute() }
        taskDict.removeAll()
    }
}

public class DelayTask {
    public let taskID: String
    public let delay: TimeInterval
    public let taskBlock: (()->())
    var timer: Timer?
    var didExecutedCallback: (()->())?

    public init(taskID: String, delay: Double, taskBlock: @escaping (()->())) {
        self.taskID = taskID
        self.delay = delay
        self.taskBlock = taskBlock
    }

    public func start()  {
        timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(execute), userInfo: nil, repeats: false)
    }

    @objc public func execute() {
        self.taskBlock()
        self.didExecutedCallback?()
    }

    public func cancel() {
        timer?.invalidate()
        timer = nil
    }
}
