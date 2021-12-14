//
//  EmptyableViewController.swift
//  OnePiece
//
//  Created by tony on 2021/12/14.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import UIKit

protocol EmptyView: UIView {
    func emptyButton() -> UIButton?
}
protocol EmptyableViewController: UIViewController {
    associatedtype EmptyViewType: EmptyView
    var emptyView: EmptyViewType { get }
    func emptyContainerView() -> UIView
    func showEmptyView()
    func hideEmptyView()
    func changeEmptyViewStatus(with hasContent: Bool)
    func didTapEmptyView()
    func didTapEmptyButton()
}
private
struct EmptyableViewControllerAssociatedKey {
    static var tapDelegate: Int = 0
    static var buttonDelegate: Int = 0
}
extension EmptyableViewController {
    private
    var tapDelegate: TargetActioinDelegate? {
        set {
            objc_setAssociatedObject(self, &EmptyableViewControllerAssociatedKey.tapDelegate, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            objc_getAssociatedObject(self, &EmptyableViewControllerAssociatedKey.tapDelegate) as? TargetActioinDelegate
        }
    }
    private
    var buttonDelegate: TargetActioinDelegate? {
        set {
            objc_setAssociatedObject(self, &EmptyableViewControllerAssociatedKey.buttonDelegate, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            objc_getAssociatedObject(self, &EmptyableViewControllerAssociatedKey.buttonDelegate) as? TargetActioinDelegate
        }
    }
    func emptyContainerView() -> UIView {
        return self.view
    }
    func showEmptyView() {
        emptyView.isHidden = false
        if emptyView.superview == nil {
            tapDelegate = TargetActioinDelegate()
            tapDelegate?.callback = {[weak self] in
                self?.didTapEmptyView()
            }
            let tap = UITapGestureRecognizer(target: tapDelegate, action: #selector(TargetActioinDelegate.action))
            emptyView.addGestureRecognizer(tap)
            buttonDelegate = TargetActioinDelegate()
            buttonDelegate?.callback = { [weak self] in
                self?.didTapEmptyButton()
            }
            emptyView.emptyButton()?.addTarget(buttonDelegate, action: #selector(TargetActioinDelegate.action), for: .touchUpInside)
            let size = emptyContainerView().bounds.size
            emptyView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            emptyContainerView().addSubview(emptyView)
        }
    }
    func hideEmptyView() {
        emptyView.isHidden = true
    }
    func changeEmptyViewStatus(with hasContent: Bool) {
        if hasContent {
            hideEmptyView()
        }else {
            showEmptyView()
        }
    }
    func didTapEmptyView() {
        
    }
    func didTapEmptyButton() {
        
    }
}

fileprivate
class TargetActioinDelegate {
    var callback: (()->())?
    @objc func action() {
        callback?()
    }
}
