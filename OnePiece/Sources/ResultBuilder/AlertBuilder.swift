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

fileprivate class ActionBox: Action {
    fileprivate var actions = [Action]()
    fileprivate init(actions: [Action]) {
        self.actions = actions
        super.init(title: "", style: .default, handler: nil)
    }
}

@resultBuilder
public struct ActionBuilder {
    public static func buildBlock(_ children: Action...) -> [Action] {
        return children
    }
    public static func buildIf(_ actions: [Action]?) -> Action {
        return ActionBox(actions: actions ?? [])
    }
    public static func buildEither(first actions: [Action]) -> Action {
        return ActionBox(actions: actions)
    }
    public static func buildEither(second actions: [Action]) -> Action {
        return ActionBox(actions: actions)
    }
}

public extension UIAlertController {
    convenience init(title: String?, message: String?, style: UIAlertController.Style, @ActionBuilder actions: () -> [Action]) {
        self.init(title: title, message: message, preferredStyle: style)
        for action in actions() {
            if let box = action as? ActionBox {
                for ifAction in box.actions {
                    self.addAction(UIAlertAction(title: ifAction.title, style: ifAction.style) { _ in
                        ifAction.handler?()
                    })
                }
            }else if let box = action as? ForEachIdentifier {
                for forEachAction in box.actions {
                    self.addAction(UIAlertAction(title: forEachAction.title, style: forEachAction.style) { _ in
                        forEachAction.handler?()
                    })
                }
            }else {
                self.addAction(UIAlertAction(title: action.title, style: action.style) { _ in
                    action.handler?()
                })
            }
        }
    }
}

public func Alert(title: String?, message: String?, @ActionBuilder actions: () -> [Action]) -> UIAlertController {
    return UIAlertController(title: title, message: message, style: .alert, actions: actions)
}

public func ActionSheet(title: String?, message: String?, @ActionBuilder actions: () -> [Action]) -> UIAlertController {
    return UIAlertController(title: title, message: message, style: .actionSheet, actions: actions)
}

public class ForEach<Data>: Action where Data : RandomAccessCollection {
    let data: Data
    var actions = [Action]()
    public init(_ data: Data, content: @escaping (Data.Element) -> Action) {
        self.data = data
        var items = [Action]()
        for item in data {
            let action = content(item)
            items.append(action)
        }
        self.actions = items
        super.init(title: "", style: .default, handler: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate protocol ForEachIdentifier {
    var actions: [Action] { get }
}
extension ForEach: ForEachIdentifier {}
