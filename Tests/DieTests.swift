//
//  DieTests.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/14/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import XCTest
@testable import Yahtzee

class DieTests: XCTestCase {

    func testInit() {
        XCTAssertEqual(Die(rawValue: 1), .one)
        XCTAssertEqual(Die(rawValue: 2), .two)
        XCTAssertEqual(Die(rawValue: 3), .three)
        XCTAssertEqual(Die(rawValue: 4), .four)
        XCTAssertEqual(Die(rawValue: 5), .five)
        XCTAssertEqual(Die(rawValue: 6), .six)
    }

    func testInitFails() {
        XCTAssertNil(Die(rawValue: 42))
    }

    func testAll() {
        XCTAssertEqual(Die.all, [.one, .two, .three, .four, .five, .six])
    }

    // TODO: Write a test the can test randomness of Die.random()
    func testRandom() {
        let times = 100
        var dice = [Die]()
        while dice.count < times {
            dice.append(Die.random())
        }
        // TODO: Calculate the standard deviation of the rolls
        // The sd should fall in known range
        // https://math.stackexchange.com/questions/2245194/what-is-the-standard-deviation-of-dice-rolling/2245228#2245228
    }
}
