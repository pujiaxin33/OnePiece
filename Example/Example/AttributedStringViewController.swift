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
            NSAttributedString(string: "开始").foregroundColor(.red).font(.systemFont(ofSize: 18))
            NSAttributedString(string: "中间").underline(.red, style: .double).font(.systemFont(ofSize: 25))
            NSAttributedString(string: "结尾").foregroundColor(.green).font(.systemFont(ofSize: 10))
            //下面这种方式暂时不行，多半是系统的问题
//            "期望".foregroundColor(.blue).font(.systemFont(ofSize: 15))
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
