//
//  DetailViewController.swift
//  Example
//
//  Created by jiaxin on 2019/12/18.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import OnePiece

class TimerViewController: UIViewController {
    lazy var timerScheduler = SafeTimerScheduler()

    override func viewDidLoad() {
        super.viewDidLoad()

        let timer1 = timerScheduler.makeTimer(timeInterval: 1, repeats: true) { (_) in
            print("1")
        }
        RunLoop.main.add(timer1, forMode: .default)

        let timer2 = timerScheduler.makeTimer(fire: Date().addingTimeInterval(5), interval: 1, repeats: true) { (_) in
            print("2")
        }
        RunLoop.main.add(timer2, forMode: .default)

        timerScheduler.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            print("3")
        }

        Timer.scheduledTimer(withLifecycleOwner: self, interval: 1, repeats: true) { (_) in
            print("4")
        }

        let timer5 = Timer(lifecycleOwner: self, timeInterval: 1, repeats: true) { (_) in
            print("5")
        }
        RunLoop.main.add(timer5, forMode: .default)

        let timer6 = Timer(lifecycleOwner: self, fire: Date().addingTimeInterval(6), interval: 1, repeats: true) { (_) in
            print("6")
        }
        RunLoop.main.add(timer6, forMode: .default)
    }
    
}
