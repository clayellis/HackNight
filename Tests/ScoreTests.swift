//
//  ScoreTests.swift
//  YahtzeeTests
//
//  Created by Clay Ellis on 5/9/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import XCTest
@testable import Yahtzee

class ScoreTests: XCTestCase {

    // MARK: Upper Section

    func testOnesOption() throws {
        try assert(1, 1, 2, 3, 4, scoreEquals: 2, using: ScoreOptions.ones)
    }

    func testTwosOption() throws {
        try assert(1, 2, 2, 3, 4, scoreEquals: 4, using: ScoreOptions.twos)
    }

    func testThreesOption() throws {
        try assert(1, 2, 2, 3, 3, scoreEquals: 6, using: ScoreOptions.threes)
    }

    func testFoursOption() throws {
        try assert(1, 2, 4, 4, 5, scoreEquals: 8, using: ScoreOptions.fours)
    }

    func testFivesOption() throws {
        try assert(1, 5, 5, 3, 2, scoreEquals: 10, using: ScoreOptions.fives)
    }

    func testSixesOption() throws {
        try assert(1, 2, 4, 6, 6, scoreEquals: 12, using: ScoreOptions.sixes)
    }

    // MARK: Lower Section

//    func testYahtzeeScoreOption() {
//        var test = YAHTZEE(roll: Roll(dice: [.one, .one, .one, .one, .one]))
//
//        XCTAssertEqual(test.score(), YAHTZEE.YAHTZEE_SCORE)
//
//        test = YAHTZEE(roll: Roll(dice: [.five, .five, .five, .five, .five]))
//
//        XCTAssertEqual(test.score(), YAHTZEE.YAHTZEE_SCORE)
//
//        test = YAHTZEE(roll: Roll(dice: [.one, .two, .three, .three, .four]))
//
//        XCTAssertEqual(test.score(), 0)
//    }
}

extension ScoreTests {
    func assert(_ d1: Int, _ d2: Int, _ d3: Int, _ d4: Int, _ d5: Int, scoreEquals expectedScore: Int, using option: ScoreOption) throws {
        let roll = try Roll(d1, d2, d3, d4, d5)
        XCTAssertEqual(option(roll), expectedScore)
    }
}
