//
//  UIResponder+Event.swift
//  OnePiece
//
//  Created by tony on 2021/11/29.
//  Copyright © 2021 jiaxin. All rights reserved.
//

import Foundation
import UIKit

@objc public class ChainEvent: NSObject {
    public var name: String
    public var sender: UIResponder
    public var payload: [String:Any]
    
    public init(name: String, sender: UIResponder, payload: [String:Any] = [String:Any]()) {
        self.name = name
        self.sender = sender
        self.payload = payload
    }
}

public protocol ChainEventResponder {
    func handleEvent(_ event: ChainEvent)
}

extension UIResponder: ChainEventResponder {
    @objc
    open func handleEvent(_ event: ChainEvent) {
        next?.handleEvent(event)
    }
}
