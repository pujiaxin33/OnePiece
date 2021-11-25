//
//  AlertViewController.swift
//  Example
//
//  Created by jiaxin on 2020/3/19.
//  Copyright © 2020 jiaxin. All rights reserved.
//

import UIKit
import OnePiece

class AlertViewController: UIViewController {
    var canEdit = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }

    func showAlert1() {
        let alert = UIAlertController(title: "标题", message: "消息", style: .alert) {
            Action.cancel("取消") {
                print("取消")
            }
            Action(title: "重要", style: .destructive) {
                print("重要")
            }
            Action(title: "默认", style: .default) {
                print("默认")
            }
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    func showAlert2() {
        let alert = Alert(title: "标题", message: "消息") {
            Action.cancel("取消") {
                print("取消")
            }
            Action(title: "重要", style: .destructive) {
                print("重要")
            }
            Action(title: "默认", style: .default) {
                print("默认")
            }
        }
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert3() {
        let alert = ActionSheet(title: "标题", message: "消息") {
            Action.cancel("取消") {
                print("取消")
            }
            Action(title: "重要", style: .destructive) {
                print("重要")
            }
            Action(title: "默认", style: .default) {
                print("默认")
            }
        }
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert4() {
        let alert = Alert(title: "标题", message: "消息") {
            Action.default("默认") {
                print("默认")
            }
            if canEdit {
                Action.destructive("编辑") {
                    print("编辑")
                }
            } else {
                Action.destructive("分享") {
                    print("分享")
                }
            }
            Action.cancel("取消")
        }
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert5() {
        let alert = Alert(title: "标题", message: "消息") {
            ForEach(["取消", "确定", "再想想"]) { string in
                Action.default(string) { print(string) }
            }
        }
        present(alert, animated: true, completion: nil)
    }
}
