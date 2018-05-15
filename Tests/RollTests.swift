//
//  RollTests.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/14/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import XCTest
@testable import Yahtzee

class RollTests: XCTestCase {

    func testInitEmptyPresets() {
        let roll = Roll()
        XCTAssertEqual(roll.dice.count, 5)
    }

    func testInitWithPresets() {
        let roll = Roll(presets: [0: .one, 1: .two, 2: .three])
        XCTAssertEqual(roll.dice[0], .one)
        XCTAssertEqual(roll.dice[1], .two)
        XCTAssertEqual(roll.dice[2], .three)
        XCTAssertEqual(roll.dice.count, 5)
    }

    func testInitWithInts() throws {
        let roll = try Roll(1, 2, 3, 4, 5)
        XCTAssertEqual(roll.dice[0], .one)
        XCTAssertEqual(roll.dice[1], .two)
        XCTAssertEqual(roll.dice[2], .three)
        XCTAssertEqual(roll.dice[3], .four)
        XCTAssertEqual(roll.dice[4], .five)
        XCTAssertEqual(roll.dice.count, 5)
    }

    func testInitWithIntsThrowsInvalidNumberOfDice() throws {
        XCTAssertThrowsError(try Roll(1, 2, 3)) { error in
            let expecting = Roll.Error.invalidNumberOfDice(3)

            guard case let Roll.Error.invalidNumberOfDice(invalidCount) = error else {
                XCTFailUnexpectedError(error, expectedError: expecting)
                return
            }

            XCTAssertEqual(invalidCount, 3)
        }
    }

    func testInitWithIntsThrowsInvalidDiceValue() throws {
        XCTAssertThrowsError(try Roll(1, 2, 3, 4, 42)) { error in
            let expecting = Roll.Error.invalidDiceValue(42)

            guard case let Roll.Error.invalidDiceValue(invalidValue) = error else {
                XCTFailUnexpectedError(error, expectedError: expecting)
                return
            }

            XCTAssertEqual(invalidValue, 42)
        }
    }
}
