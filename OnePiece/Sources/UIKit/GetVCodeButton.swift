//
//  GetVCodeButton.swift
//  OnePiece
//
//  Created by tony on 2021/11/29.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import UIKit

class GetVCodeButton: UIButton {

    enum Status {
        case normal
        case countdown
        case retry
    }
    
    var status: GetVCodeButton.Status = .normal {
        didSet {
            if status == .countdown {
                startCountDownTimer()
            }
            refreshUI()
        }
    }
    var countDownSeconds: TimeInterval = 60
    private var currentSeconds: TimeInterval = 60
    private var timer: Timer?
    override var intrinsicContentSize: CGSize {
        return .init(width: 68, height: 23)
    }
    
    deinit {
        invalidTimer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initializeViews()
    }
    
    func initializeViews() {
        titleLabel?.font = .systemFont(ofSize: 11)
        refreshUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.size.height/2
    }
    
    func refreshUI() {
        switch status {
        case .normal:
            isEnabled = true
            setTitle("获取验证码", for: .normal)
            setTitleColor(UIColor.black, for: .normal)
            backgroundColor = UIColor.lightGray
            layer.borderColor = nil
            layer.borderWidth = 0
        case .countdown:
            isEnabled = false
            setTitle("\(Int(currentSeconds))s", for: .normal)
            setTitleColor(UIColor.red, for: .normal)
            backgroundColor = UIColor.lightGray
            layer.borderColor = UIColor.red.cgColor
            layer.borderWidth = 1
        case .retry:
            isEnabled = true
            setTitle("重新获取", for: .normal)
            setTitleColor(UIColor.red, for: .normal)
            backgroundColor = UIColor.gray
            layer.borderColor = nil
            layer.borderWidth = 0
        }
    }
    
    private func startCountDownTimer() {
        invalidTimer()
        timer = Timer.init(timeInterval: 1, repeats: true, block: {[weak self] _ in
            self?.processCountDown()
        })
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    private func processCountDown() {
        currentSeconds -= 1
        if currentSeconds <= 0 {
            status = .retry
            currentSeconds = countDownSeconds
            invalidTimer()
        }else {
            refreshUI()
        }
    }
    
    private func invalidTimer() {
        timer?.invalidate()
        timer = nil
    }
}

