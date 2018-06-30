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
        try assert(1, 1, 2, 3, 4, scoreEquals: 2, using: .ones)
    }

    func testTwosOption() throws {
        try assert(1, 2, 2, 3, 4, scoreEquals: 4, using: .twos)
    }

    func testThreesOption() throws {
        try assert(1, 2, 2, 3, 3, scoreEquals: 6, using: .threes)
    }

    func testFoursOption() throws {
        try assert(1, 2, 4, 4, 5, scoreEquals: 8, using: .fours)
    }

    func testFivesOption() throws {
        try assert(1, 5, 5, 3, 2, scoreEquals: 10, using: .fives)
    }

    func testSixesOption() throws {
        try assert(1, 2, 4, 6, 6, scoreEquals: 12, using: .sixes)
    }

    // MARK: Lower Section

    func testThreeOfAKind() throws {
        try assert(1, 1, 1, 3, 5, scoreEquals: 11, using: .threeOfAKind)
        try assert(1, 2, 3, 4, 5, scoreEquals: 0, using: .threeOfAKind)
    }

    func testFourOfAKind() throws {
        try assert(3, 3, 3, 3, 2, scoreEquals: 14, using: .fourOfAKind)
        try assert(1, 2, 3, 4, 5, scoreEquals: 0, using: .fourOfAKind)
    }

    func testFullHouse() throws {
        try assert(1, 1, 1, 2, 2, scoreEquals: 25, using: .fullHouse)
        try assert(1, 1, 1, 1, 1, scoreEquals: 25, using: .fullHouse)
        try assert(1, 2, 3, 4, 5, scoreEquals: 0, using: .fullHouse)
    }

    func testSmallStraight() throws {
        try assert(1, 2, 3, 4, 1, scoreEquals: 30, using: .smallStraight)
        try assert(5, 2, 3, 4, 5, scoreEquals: 30, using: .smallStraight)
        try assert(5, 3, 4, 5, 6, scoreEquals: 30, using: .smallStraight)
        try assert(1, 1, 1, 1, 1, scoreEquals: 0, using: .smallStraight)
    }

    func testLargeStraight() throws {
        try assert(1, 2, 3, 4, 5, scoreEquals: 40, using: .largeStriaght)
        try assert(2, 3, 4, 5, 6, scoreEquals: 40, using: .largeStriaght)
        try assert(1, 1, 1, 1, 1, scoreEquals: 0, using: .largeStriaght)
    }

    func testYahtzee() throws {
        try assert(5, 5, 5, 5, 5, scoreEquals: 50, using: .yahtzee)
        try assert(1, 2, 3, 4, 5, scoreEquals: 0, using: .yahtzee)
    }

    func testChance() throws {
        try assert(1, 3, 4, 6, 2, scoreEquals: 16, using: .chance)
    }

    func testSections() {
        XCTAssertEqual(ScoreOption.upperSection, [.ones, .twos, .threes, .fours, .fives, .sixes])
        XCTAssertEqual(ScoreOption.lowerSection, [.threeOfAKind, .fourOfAKind, .fullHouse, .smallStraight, .largeStriaght, .yahtzee, .chance])
    }
}

extension ScoreTests {
    func assert(_ d1: Int, _ d2: Int, _ d3: Int, _ d4: Int, _ d5: Int,
                scoreEquals expectedScore: Int, using option: ScoreOption,
                file: StaticString = #file, line: UInt = #line) throws {
        let roll = try Roll(d1, d2, d3, d4, d5)
        XCTAssertEqual(option.score(for: roll), expectedScore, file: file, line: line)
    }
}
