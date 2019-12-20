//
//  ViewController.swift
//  Example
//
//  Created by jiaxin on 2019/12/18.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import OnePiece

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        var text: String?
        for view in cell.contentView.subviews {
            if let label = view as? UILabel {
                text = label.text
                break
            }
        }
        guard let title = text else {
            return
        }
        switch title {
        case "Timer":
            let vc = TimerViewController()
            vc.title = title
            navigationController?.pushViewController(vc, animated: true)
        case "Lifecycle":
            let vc = GifViewController()
            vc.title = title
            navigationController?.pushViewController(vc, animated: true)
        case "ImageGuide":
            let images = [UIImage.imageWithColor(color: .red), UIImage.imageWithColor(color: .green), UIImage.imageWithColor(color: .blue)]
            let vc = ImageGuideViewController(images: images)
            vc.show()
        default:
            break
        }
    }
}

