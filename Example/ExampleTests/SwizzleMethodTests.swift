//
//  SwizzleMethodTests.swift
//  ExampleTests
//
//  Created by jiaxin on 2019/12/18.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import XCTest
import OnePiece


extension UIView {
    static let executeSwizzleMethod: Void = {
        swizzleInstanceMethod(target: UIView(), originalSelector: #selector(addSubview(_:)), newSelector: #selector(swizzledAddSubview(_:)))
        swizzleClassMethod(target: UIView(), originalSelector: #selector(setAnimationsEnabled(_:)), newSelector: #selector(swizzledSetAnimationsEnabled(_:)))
    }()
    @objc private func swizzledAddSubview(_ view: UIView) {
        swizzledAddSubview(view)
        let label = UILabel()
        swizzledAddSubview(label)
    }
    @objc private class func swizzledSetAnimationsEnabled(_ enabled: Bool) {
        swizzledSetAnimationsEnabled(true)
    }
}

class SwizzleMethodTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        UIView.executeSwizzleMethod
        let view = UIView()
        assert(view.subviews.isEmpty)
        let label = UILabel()
        view.addSubview(label)
        assert(view.subviews.count == 2)

        UIView.setAnimationsEnabled(false)
        assert(UIView.areAnimationsEnabled)
    }



}
