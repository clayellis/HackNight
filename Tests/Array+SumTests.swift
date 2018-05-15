//
//  Array+SumTests.swift
//  YahtzeeTests
//
//  Created by Clay Ellis on 5/14/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import XCTest
@testable import Yahtzee

class Array_SumTests: XCTestCase {
    
    func testArraySum() {
        let dice: [Die] = [.one, .two, .three, .four, .five, .six]
        XCTAssertEqual(dice.sum(), 21)
    }
    
}
