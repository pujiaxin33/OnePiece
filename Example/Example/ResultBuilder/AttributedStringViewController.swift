//
//  AttributedStringViewController.swift
//  Example
//
//  Created by jiaxin on 2020/3/19.
//  Copyright © 2020 jiaxin. All rights reserved.
//

import UIKit
import OnePiece

class AttributedStringViewController: UIViewController {
    lazy var contentLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let attri = NSAttributedString {
            AText("开始").foregroundColor(.red).font(.systemFont(ofSize: 18))
            AText("中间").underline(.red, style: .double).font(.systemFont(ofSize: 25))
            AText("结尾").foregroundColor(.green).font(.systemFont(ofSize: 10)).apply([.backgroundColor: UIColor.lightGray])
        }
        contentLabel.attributedText = attri
        view.addSubview(contentLabel)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        contentLabel.sizeToFit()
        contentLabel.center = view.center
    }


}
