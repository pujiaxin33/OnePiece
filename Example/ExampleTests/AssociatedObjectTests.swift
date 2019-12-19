//
//  AssociatedObjectTests.swift
//  ExampleTests
//
//  Created by jiaxin on 2019/12/18.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import XCTest
import OnePiece

extension AssociatedObjectKey {
    static var testKey: UInt8 = 0
    static var initialKey: UInt8 = 0
    static var stateKey: UInt8 = 0
}

class AssociatedObjectTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        setAssociatedObject(key: &AssociatedObjectKey.testKey, value: "ok", plicy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        let result: String? = associatedObject(key: &AssociatedObjectKey.testKey)
        assert(result! == "ok")

        setAssociatedObject(key: &AssociatedObjectKey.stateKey, value: true, plicy: .OBJC_ASSOCIATION_ASSIGN)
        let state: Bool? = associatedObject(key: &AssociatedObjectKey.stateKey, initial: { return (false, .OBJC_ASSOCIATION_ASSIGN) })
        assert(state == true)
    }

    func testInitial() {
        let result = associatedObject(key: &AssociatedObjectKey.initialKey) { return ("initial", .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
        assert(result == "initial")
    }
}
