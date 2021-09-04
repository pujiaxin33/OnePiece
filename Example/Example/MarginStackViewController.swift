//
//  MarginStackViewController.swift
//  Example
//
//  Created by tony on 2021/9/4.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import UIKit
import OnePiece

class MarginStackViewController: UIViewController {
    let stackView = MarginStackView()
    let textLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 0
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true

        let headerLabel = UILabel()
        headerLabel.text = "这是头部标题"
        stackView.addArrangedSubview(headerLabel, with: .init(top: 0, bottom: 0, left: 50, right: 0))
        
        textLabel.numberOfLines = 0
        textLabel.text = "这是文本描述!\n这是文本描述!\n这是文本描述!"
        stackView.addArrangedSubview(textLabel, with: .init(top: 20, bottom: 0, left: 0, right: 0))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        
        stackView.removeArrangedSubview(textLabel)
        textLabel.removeFromSuperview()
    }

}
