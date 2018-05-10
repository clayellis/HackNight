//
//  YahtzeeTests.swift
//  YahtzeeTests
//
//  Created by Clay Ellis on 5/9/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import XCTest
@testable import Yahtzee

class YahtzeeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidRoll() {
        XCTAssertNoThrow(try Roll(dice: [.one, .two, .three, .four, .five]))
    }

    func testInvalidRollCount() {
        let dice: [Die] = [.one, .two]
        XCTAssertThrowsError(try Roll(dice: dice), "Invalid roll count, too few.") { error in
            guard let rollError = error as? Roll.Error else {
                XCTFail("Expected a Roll.Error")
                return
            }

            switch rollError {
            case .invalidNumberOfDice(let count):
                XCTAssertEqual(count, dice.count)
            }
        }
    }
    
}
