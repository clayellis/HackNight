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

    func testOnesScoreOption() {
        let roll = Roll(dice: [.one, .one, .two, .three])
    }

    // Yo Danny Boy

    func testYahtzeeScoreOption() {
        var test = YAHTZEE(roll: Roll(dice: [.one, .one, .one, .one, .one]))

        XCTAssertEqual(test.score(), YAHTZEE.YAHTZEE_SCORE)

        test = YAHTZEE(roll: Roll(dice: [.five, .five, .five, .five, .five]))

        XCTAssertEqual(test.score(), YAHTZEE.YAHTZEE_SCORE)

        test = YAHTZEE(roll: Roll(dice: [.one, .two, .three, .three, .four]))

        XCTAssertEqual(test.score(), 0)
    }
}
