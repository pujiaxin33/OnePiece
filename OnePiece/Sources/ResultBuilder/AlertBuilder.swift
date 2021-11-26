//
//  AlertBuilder.swift
//  OnePiece
//
//  Created by jiaxin on 2020/3/19.
//  Copyright © 2020 jiaxin. All rights reserved.
//

import Foundation
import UIKit

public protocol ActionsConvertible {
    func asActions() -> [Action]
}
extension Array: ActionsConvertible where Element == Action {
    public func asActions() -> [Action] {
        return self
    }
}
extension Action: ActionsConvertible {
    public func asActions() -> [Action] {
        return [self]
    }
}
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

@resultBuilder
public struct ActionBuilder {
    public static func buildBlock(_ children: ActionsConvertible...) -> [Action] {
        return children.flatMap { $0.asActions() }
    }
    public static func buildIf(_ actions: ActionsConvertible?) -> ActionsConvertible {
        return actions ?? []
    }
    public static func buildEither(first actions: ActionsConvertible) -> ActionsConvertible {
        return actions
    }
    public static func buildEither(second actions: ActionsConvertible) -> ActionsConvertible {
        return actions
    }
}

public extension UIAlertController {
    convenience init(title: String?, message: String?, style: UIAlertController.Style, @ActionBuilder actions: () -> [Action]) {
        self.init(title: title, message: message, preferredStyle: style)
        for action in actions() {
            self.addAction(UIAlertAction(title: action.title, style: action.style) { _ in
                action.handler?()
            })
        }
    }
}

public func Alert(title: String?, message: String?, @ActionBuilder actions: () -> [Action]) -> UIAlertController {
    return UIAlertController(title: title, message: message, style: .alert, actions: actions)
}

public func ActionSheet(title: String?, message: String?, @ActionBuilder actions: () -> [Action]) -> UIAlertController {
    return UIAlertController(title: title, message: message, style: .actionSheet, actions: actions)
}

public class ForEach<Data> where Data : RandomAccessCollection {
    let data: Data
    var actions = [Action]()
    public init(_ data: Data, @ActionBuilder content: @escaping (Data.Element) -> [Action]) {
        self.data = data
        var items = [Action]()
        for item in data {
            let actions = content(item)
            items.append(contentsOf: actions)
        }
        self.actions = items
    }
}
extension ForEach: ActionsConvertible {
    public func asActions() -> [Action] {
        return actions
    }
}
