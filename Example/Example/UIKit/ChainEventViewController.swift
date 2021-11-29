//
//  ChainEventViewController.swift
//  Example
//
//  Created by tony on 2021/11/29.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import UIKit
import OnePiece

class ChainEventViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let eventView = ChainEventView(frame: .init(x: 0, y: 200, width: view.bounds.size.width, height: 200))
        eventView.backgroundColor = .lightGray
        view.addSubview(eventView)
    }
    
    
    override func handleEvent(_ event: ChainEvent) {
        if event.name == "SendEvent" {
            if let message = event.payload["data"] as? String {
                print(message)
            }
        }else {
            super.handleEvent(event)
        }
    }
}


class ChainEventView: UIView {
    let btn = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        btn.setTitle("发送事件", for: .normal)
        btn.addTarget(self, action: #selector(sendEventBtnDicClicked(_:)), for: .touchUpInside)
        addSubview(btn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        btn.sizeToFit()
        btn.center = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
    }
    
    @objc func sendEventBtnDicClicked(_ btn: UIButton) {
        handleEvent(.init(name: "SendEvent", sender: btn, payload: ["data": "hello world!"]))
    }
}
