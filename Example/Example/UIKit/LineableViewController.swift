//
//  LineableViewController.swift
//  Example
//
//  Created by tony on 2021/11/29.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import UIKit
import OnePiece

class LineableViewController: UIViewController {
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var topAndBottomLabel: UILabel!
    @IBOutlet weak var leftAndRightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topLabel.line.addTop(lineWidth: 2, insets: .init(top: 5, left: 10, bottom: 0, right: 10), lineColor: .red)
        leftLabel.line.addLeading(lineWidth: 2, insets: .init(top: 10, left: 0, bottom: 10, right: 0), lineColor: .red)
        bottomLabel.line.addBottom(lineWidth: 2, insets: .init(top: 0, left: 0, bottom: 10, right: 10), lineColor: .red)
        rightLabel.line.addTrailinng(lineWidth: 2, insets: .init(top: 10, left: 0, bottom: 10, right: 0), lineColor: .red)
        topAndBottomLabel.line.addTop(lineWidth: 2, insets: .init(top: 0, left: 0, bottom: 0, right: 0), lineColor: .red)
        topAndBottomLabel.line.addBottom(lineWidth: 2, insets: .init(top: 0, left: 0, bottom: 10, right: 0), lineColor: .red)
        leftAndRightLabel.line.addLeading(lineWidth: 2, lineColor: .red)
        leftAndRightLabel.line.addTrailinng(lineWidth: 2, lineColor: .red)
    }
    

}
