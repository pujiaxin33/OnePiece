//
//  ViewController.swift
//  Example
//
//  Created by jiaxin on 2019/12/18.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import OnePiece

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = GifViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}

