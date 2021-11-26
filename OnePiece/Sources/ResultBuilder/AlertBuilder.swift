//
//  AlertBuilder.swift
//  OnePiece
//
//  Created by jiaxin on 2020/3/19.
//  Copyright © 2020 jiaxin. All rights reserved.
//

import Foundation
import UIKit

public class Action {
    public var title: String
    public var style: UIAlertAction.Style
    public var handler: (()->Void)?
    
    public init(title: String, style: UIAlertAction.Style, handler: (()->Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
    public static func `default`(_ title: String, handler: (()->Void)? = nil) -> Action {
        return Action(title: title, style: .default, handler: handler)
    }
    public static func cancel(_ title: String, handler: (()->Void)? = nil) -> Action {
        return Action(title: title, style: .cancel, handler: handler)
    }
    public static func destructive(_ title: String, handler: (()->Void)? = nil) -> Action {
        return Action(title: title, style: .destructive, handler: handler)
    }
}

public extension UIAlertController {
    convenience init(title: String?, message: String?, style: UIAlertController.Style, @AnyBuilder<Action> actions: () -> [Action]) {
        self.init(title: title, message: message, preferredStyle: style)
        for action in actions() {
            self.addAction(UIAlertAction(title: action.title, style: action.style) { _ in
                action.handler?()
            })
        }
    }
}

public func Alert(title: String?, message: String?, @AnyBuilder<Action> actions: () -> [Action]) -> UIAlertController {
    return UIAlertController(title: title, message: message, style: .alert, actions: actions)
}

public func ActionSheet(title: String?, message: String?, @AnyBuilder<Action> actions: () -> [Action]) -> UIAlertController {
    return UIAlertController(title: title, message: message, style: .actionSheet, actions: actions)
}

