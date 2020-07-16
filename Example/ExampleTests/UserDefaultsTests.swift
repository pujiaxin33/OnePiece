//
//  UserDefaultsTests.swift
//  ExampleTests
//
//  Created by jiaxin on 2019/12/18.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import XCTest
import OnePiece

extension UserDefaultsKey {
    static let testArray = "testArray"
}

class UserDefaultsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let result = UserDefaults.standard.array(forKey: UserDefaultsKey.testArray, defaultValue: [1, 2, 3])
        assert(result.count == 3)

        let textKey = DefaultsKey<String?>.init("some")
        let text = Defaults[textKey]
        print(text ?? "")
        
        let intKey = DefaultsKey<Int>.init(key: "int", defaultValue: 3)
        print(Defaults[intKey])

        
    }


}
