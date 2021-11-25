//
//  AttributedStringBuilder.swift
//  OnePiece
//
//  Created by jiaxin on 2020/3/19.
//  Copyright © 2020 jiaxin. All rights reserved.
//

import UIKit

@resultBuilder
public struct AttributedStringBuilder {
    public static func buildBlock(_ components: NSAttributedString...) -> NSAttributedString {
        let result = NSMutableAttributedString()
        components.forEach { result.append($0) }
        return result
    }

    public static func buildIf(_ component: NSAttributedString?) -> NSAttributedString {
        //todo
        return component ?? NSAttributedString(string: "")
    }

    public static func buildEither(first component: NSAttributedString) -> NSAttributedString {
        return component
    }

    public static func buildEither(second component: NSAttributedString) -> NSAttributedString {
        return component
    }
}

public extension NSAttributedString {
    convenience init(@AttributedStringBuilder _ content: () -> NSAttributedString ) {
        self.init(attributedString: content())
    }
}

public extension NSAttributedString {
    func foregroundColor(_ color: UIColor) -> NSAttributedString {
        self.apply([.foregroundColor : color])
    }
    func background(_ color: UIColor) -> NSAttributedString {
        self.apply([.backgroundColor: color])
    }
    func underline(_ color: UIColor, style: NSUnderlineStyle = .single) -> NSAttributedString {
        self.apply([.underlineColor: color, .underlineStyle: style.rawValue])
    }
    func font(_ font: UIFont) -> NSAttributedString {
        self.apply([.font: font])
    }
    func shadow(_ shadow: NSShadow) -> NSAttributedString {
        self.apply([.shadow:shadow])
    }
    func link(_ link: URL) -> NSAttributedString {
        self.apply([.link:link])
    }
    //todo
}

public extension NSAttributedString {
    func apply(_ attributes: [NSAttributedString.Key:Any]) -> NSAttributedString {
        let mutable = NSMutableAttributedString(string: self.string, attributes: self.attributes(at: 0, effectiveRange: nil))
        mutable.addAttributes(attributes, range: NSMakeRange(0, (self.string as NSString).length))
        return mutable
    }
}

public func AText(_ string: String) -> NSAttributedString {
    return NSAttributedString(string: string)
}
