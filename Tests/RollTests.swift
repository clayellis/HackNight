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
        let roll = try Roll(strict: 1, 2, 3, 4, 5)
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

    func testReroll() throws {
        let roll = Roll()
        let reroll = try roll.reroll(savingDiceAt: 0, 1)
        XCTAssertEqual(roll.dice[0], reroll.dice[0])
        XCTAssertEqual(roll.dice[1], reroll.dice[1])
    }

    func testRerollThrowsInvalidPosition() throws {
        XCTAssertThrowsError(try Roll().reroll(savingDiceAt: 42)) { error in
            let expecting = Roll.Error.invalidPosition(42)

            guard case let Roll.Error.invalidPosition(invalidPosition) = error else {
                XCTFailUnexpectedError(error, expectedError: expecting)
                return
            }

            XCTAssertEqual(invalidPosition, 42)
        }
    }

    func testRollSumOf() throws {
        let roll = try Roll(strict: 1, 1, 1, 2, 3)
        XCTAssertEqual(roll.sum(of: .one), 3)
    }

    func testRollSum() throws {
        let roll = try Roll(strict: 1, 2, 3, 4, 5)
        XCTAssertEqual(roll.sum(), 15)
    }

    func testRollCountPerDie() throws {
        let roll = try Roll(strict: 1, 1, 2, 2, 5)
        let counts = roll.countPerDie()
        XCTAssertEqual(counts[.one], 2)
        XCTAssertEqual(counts[.two], 2)
        XCTAssertEqual(counts[.three], 0)
        XCTAssertEqual(counts[.four], 0)
        XCTAssertEqual(counts[.five], 1)
    }

    func testRollCountOfDie() throws {
        let roll = try Roll(strict: 1, 2, 2, 3, 4)
        XCTAssertEqual(roll.count(of: .one), 1)
        XCTAssertEqual(roll.count(of: .two), 2)
        XCTAssertEqual(roll.count(of: .three), 1)
        XCTAssertEqual(roll.count(of: .four), 1)
        XCTAssertEqual(roll.count(of: .five), 0)
        XCTAssertEqual(roll.count(of: .six), 0)
    }

    func testRollHasCountOfDie() throws {
        let roll = try Roll(strict: 1, 1, 1, 2, 2)
        XCTAssertTrue(roll.hasCount(3, of: .one))
        XCTAssertTrue(roll.hasCount(2, of: .two))
        XCTAssertFalse(roll.hasCount(5, of: .five))
    }

    func testRollHasCountOfAKind() throws {
        let roll = try Roll(strict: 1, 1, 1, 1, 2)
        XCTAssertTrue(roll.hasCountOfAKind(count: 4))
        XCTAssertFalse(roll.hasCountOfAKind(count: 5))
    }

    func testRollHasSequenceOfLength() throws {
        let roll = try Roll(strict: 1, 1, 2, 3, 4)
        XCTAssertTrue(roll.hasSequence(ofLength: 4))
        XCTAssertFalse(roll.hasSequence(ofLength: 5))
    }
}
