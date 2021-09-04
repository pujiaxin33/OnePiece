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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let alert = Alert(title: "title", message: "消息") {
//            Action(title: "好的", style: .cancel) {
//                print("好的")
//            }
//            Action(title: "什么", style: .destructive) {
//                print("什么")
//            }
//            Action(title: "哈哈", style: .default) {
//                print("哈哈")
//            }
//        }
//        let alert = UIAlertController(title: "标题", message: "消息", style: .alert) {
//            Action.cancel("第一") {
//                print("第一")
//            }
//            Action(title: "什么", style: .destructive) {
//                print("什么")
//            }
//            Action(title: "哈哈", style: .default) {
//                print("哈哈")
//            }
//        }
//        alert.show(in: self)

//        let alertController = Alert(title: "DSf ", message: "Are you sure?") {
//            Action.default("Delete") { /* ... */ }
////            if canEdit {
////                Action.destructive("Edit") { /* ... */ }
////            } else {
////                Action.destructive("Share") { /* ... */ }
////            }
//            Action.cancel("Cancel")
//        }

//        let dynamicAlertController = Alert(title: "Title", message: "Message") {
//            ForIn(["Action1", "Action2"]) { string in
//                Action.default(string) { print(string) }
//            }
//        }
//        dynamicAlertController.show(in: self)
    }

}
