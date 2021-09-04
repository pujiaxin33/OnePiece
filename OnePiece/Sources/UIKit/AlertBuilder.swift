//
//  AlertBuilder.swift
//  OnePiece
//
//  Created by jiaxin on 2020/3/19.
//  Copyright © 2020 jiaxin. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

public struct Action {
    public var title: String
    public var style: UIAlertAction.Style
    public var handler: ()->Void

    public init(title: String, style: UIAlertAction.Style, handler: @escaping ()->Void) {
        self.title = title
        self.style = style
        self.handler = handler
    }
    public static func `default`(_ title: String, handler: @escaping ()->Void) -> Action {
        return Action(title: title, style: .default, handler: handler)
    }
    public static func cancel(_ title: String, handler: @escaping ()->Void) -> Action {
        return Action(title: title, style: .cancel, handler: handler)
    }
    public static func destructive(_ title: String, handler: @escaping ()->Void) -> Action {
        return Action(title: title, style: .destructive, handler: handler)
    }
}

@_functionBuilder
public struct ActionBuilder {
    public static func buildBlock(_ children: Action...) -> [Action] {
        return children
    }
    public static func buildIf(_ actions: Action?) -> Action? {
        return actions
    }
    public static func buildEither(first actions: Action) -> Action {
        return actions
    }
    public static func buildEither(second actions: Action) -> Action {
        return actions
    }
}

public extension UIAlertController {
    convenience init(title: String?, message: String?, style: UIAlertController.Style, @ActionBuilder actions: () -> [Action]) {
        self.init(title: title, message: message, preferredStyle: style)
        for action in actions() {
            self.addAction(UIAlertAction(title: action.title, style: action.style) { _ in
                action.handler()
            })
        }
    }
    func show(in viewController: UIViewController, animated flag: Bool = true, completion: (() -> Void)? = nil) {
        viewController.present(self, animated: flag, completion: completion)
    }
}

public func Alert(title: String?, message: String?, @ActionBuilder actions: () -> [Action]) -> UIAlertController {
    return UIAlertController(title: title, message: message, style: .alert, actions: actions)
}

public func ActionSheet(title: String?, message: String?, @ActionBuilder actions: () -> [Action]) -> UIAlertController {
    return UIAlertController(title: title, message: message, style: .actionSheet, actions: actions)
}

public func ForIn<S: Sequence>(_ sequence: S, actions: (S.Element) -> Action) -> [Action] {
    return sequence.map(actions)
}
