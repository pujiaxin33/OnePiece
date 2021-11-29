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
    var isShowName: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let index = 3
        contentLabel.numberOfLines = 0
        let attri = NSAttributedString {
            AText("开始").foregroundColor(.red).font(.systemFont(ofSize: 18))
            AText("中间").underline(.red, style: .double).font(.systemFont(ofSize: 25))
            AText("结尾").foregroundColor(.green).font(.systemFont(ofSize: 10)).apply([.backgroundColor: UIColor.lightGray])
            AText("\n")
            ForEach(["ForEach:a", "ForEach:b", "ForEach:c"]) { string in
                AText(string)
                AText("\n")
            }
            for string in ["ForEach:a", "ForEach:b", "ForEach:c"] {
                AText(string)
            }
            if self.isShowName {
                AText("if true show One Piece")
            }
            AText("\n")
            switch index {
            case 1:
                AText("1")
            case 2:
                AText("2")
            case 3:
                AText("switch index:\(3)")
            default: AText("")
            }
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
