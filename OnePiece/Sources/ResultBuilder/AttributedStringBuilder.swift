//
//  AttributedStringBuilder.swift
//  OnePiece
//
//  Created by jiaxin on 2020/3/19.
//  Copyright © 2020 jiaxin. All rights reserved.
//

import UIKit

public extension NSAttributedString {
    convenience init(@AnyBuilder<NSAttributedString> _ strings: () -> [NSAttributedString] ) {
        let result = NSMutableAttributedString()
        strings().forEach { result.append($0) }
        self.init(attributedString: result)
    }
}

public extension NSAttributedString {
    func font(_ font: UIFont) -> NSAttributedString {
        self.apply([.font: font])
    }
    func foregroundColor(_ color: UIColor) -> NSAttributedString {
        self.apply([.foregroundColor : color])
    }
    func background(_ color: UIColor) -> NSAttributedString {
        self.apply([.backgroundColor: color])
    }
    func paragraphStyle(_ paragraphStyle: NSParagraphStyle) -> NSAttributedString {
        self.apply([.paragraphStyle: paragraphStyle])
    }
    func ligature(_ ligature: Int) -> NSAttributedString {
        self.apply([.ligature: ligature])
    }
    func kern(_ kern: Int) -> NSAttributedString {
        self.apply([.kern: kern])
    }
    @available(iOS 14.0, *)
    func tracking(_ tracking: Int) -> NSAttributedString {
        self.apply([.tracking: tracking])
    }
    func strikethroughStyle(_ strikethroughStyle: Int) -> NSAttributedString {
        self.apply([.strikethroughStyle: strikethroughStyle])
    }
    func underline(_ color: UIColor, style: NSUnderlineStyle = .single) -> NSAttributedString {
        self.apply([.underlineColor: color, .underlineStyle: style.rawValue])
    }
    func strokeColor(_ color: UIColor) -> NSAttributedString {
        self.apply([.strokeColor : color])
    }
    func strokeWidth(_ strokeWidth: CGFloat) -> NSAttributedString {
        self.apply([.strokeWidth: strokeWidth])
    }
    func shadow(_ shadow: NSShadow) -> NSAttributedString {
        self.apply([.shadow: shadow])
    }
    func textEffect(_ textEffect: String) -> NSAttributedString {
        self.apply([.textEffect: textEffect])
    }
    func attachment(_ attachment: NSTextAttachment) -> NSAttributedString {
        self.apply([.attachment: attachment])
    }
    func link(_ link: URL) -> NSAttributedString {
        self.apply([.link: link])
    }
    func baselineOffset(_ baselineOffset: CGFloat) -> NSAttributedString {
        self.apply([.baselineOffset: baselineOffset])
    }
    func underlineColor(_ underlineColor: UIColor) -> NSAttributedString {
        self.apply([.underlineColor: underlineColor])
    }
    func strikethroughColor(_ strikethroughColor: UIColor) -> NSAttributedString {
        self.apply([.strikethroughColor: strikethroughColor])
    }
    func obliqueness(_ obliqueness: CGFloat) -> NSAttributedString {
        self.apply([.obliqueness: obliqueness])
    }
    func expansion(_ expansion: CGFloat) -> NSAttributedString {
        self.apply([.expansion: expansion])
    }
    func writingDirection(_ writingDirection: [NSWritingDirection]) -> NSAttributedString {
        self.apply([.writingDirection: writingDirection.map{$0.rawValue}])
    }
    func verticalGlyphForm(_ verticalGlyphForm: Bool) -> NSAttributedString {
        self.apply([.verticalGlyphForm: verticalGlyphForm])
    }
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
