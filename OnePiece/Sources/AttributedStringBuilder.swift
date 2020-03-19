//
//  AttributedStringBuilder.swift
//  OnePiece
//
//  Created by jiaxin on 2020/3/19.
//  Copyright © 2020 jiaxin. All rights reserved.
//

import Foundation
import UIKit
//import SwiftUI

@_functionBuilder
public struct AttributedStringBuilder {
    public static func buildBlock(_ segments: NSAttributedString...) -> NSAttributedString {
        let string = NSMutableAttributedString()
        segments.forEach { string.append($0) }
        return string
    }
    public static func buildIf(_ segment: NSAttributedString?) -> NSAttributedString {
        segment ?? NSAttributedString()
    }
}

public extension NSAttributedString {
    convenience init(@AttributedStringBuilder _ content: () -> NSAttributedString) {
        self.init(attributedString: content())
    }
}

public extension String {
    /// Sets the color of this text
    func foregroundColor(_ color: UIColor) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.foregroundColor : color])
    }
    /// Sets the background color
    func background(_ color: UIColor) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.backgroundColor: color])
    }
    /// Applies an underline to the text
    func underline(_ color: UIColor, style: NSUnderlineStyle = .single) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.underlineColor: color, .underlineStyle: style.rawValue])
    }
    /// Sets the font for this text
    func font(_ font: UIFont) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.font: font])
    }
    /// Adds a shadow to this text
    func shadow(_ shadow: NSShadow) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.shadow: shadow])
    }
    /// Returns this string as an `NSAttributedString`
    var attributed: NSAttributedString {
        NSAttributedString(string: self)
    }
}

public extension NSAttributedString {
    /// Sets the color of this text
    func foregroundColor(_ color: UIColor) -> NSAttributedString {
        self.apply([.foregroundColor : color])
    }
    /// Sets the background color
    func background(_ color: UIColor) -> NSAttributedString {
        self.apply([.backgroundColor: color])
    }
    /// Applies an underline to the text
    func underline(_ color: UIColor, style: NSUnderlineStyle = .single) -> NSAttributedString {
        self.apply([.underlineColor: color, .underlineStyle: style.rawValue])
    }
    /// Sets the font for this text
    func font(_ font: UIFont) -> NSAttributedString {
        self.apply([.font: font])
    }
    /// Adds a shadow to this text
    func shadow(_ shadow: NSShadow) -> NSAttributedString {
        self.apply([.shadow:shadow])
    }
}

public extension NSAttributedString {
    func apply(_ attributes: [NSAttributedString.Key:Any]) -> NSAttributedString {
        let mutable = NSMutableAttributedString(string: self.string, attributes: self.attributes(at: 0, effectiveRange: nil))
        mutable.addAttributes(attributes, range: NSMakeRange(0, (self.string as NSString).length))
        return mutable
    }
}
