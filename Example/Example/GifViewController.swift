//
//  GifViewController.swift
//  Example
//
//  Created by jiaxin on 2019/12/19.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import OnePiece

class GifViewController: UIViewController, LifecycleOwner {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)

//        let gif = GifImageView()
//        addLifecycleObserver(gif)

        let lifeView = LifeView()
        view.addSubview(lifeView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = UIViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}
