//
//  ScoreOptions.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/9/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import Foundation

typealias ScoreOption = (Roll) -> Int

// MARK: - Upper Section

struct ScoreOptions {
    private init() {}

    static var allOptions: [ScoreOption] {
        return [
            ones, twos, threes, fours, fives, sixes,
            threeOfAKind, fourOfAKind, fullHouse,
            smallStraight, largeStriaght,
            yahtzee, chance
        ]
    }

    // MARK: - Upper Section

    static func ones(for roll: Roll) -> Int {
        return roll.sum(of: .one)
    }

    static func twos(for roll: Roll) -> Int {
        return roll.sum(of: .two)
    }

    static func threes(for roll: Roll) -> Int {
        return roll.sum(of: .three)
    }

    static func fours(for roll: Roll) -> Int {
        return roll.sum(of: .four)
    }

    static func fives(for roll: Roll) -> Int {
        return roll.sum(of: .five)
    }

    static func sixes(for roll: Roll) -> Int {
        return roll.sum(of: .six)
    }

    // MARK: - Lower Section

    static func threeOfAKind(for roll: Roll) -> Int {
        if roll.hasCountOfAKind(count: 3) {
            return roll.sum()
        } else {
            return 0
        }
    }

    static func fourOfAKind(for roll: Roll) -> Int {
        if roll.hasCountOfAKind(count: 4) {
            return roll.sum()
        } else {
            return 0
        }
    }

    static func fullHouse(for roll: Roll) -> Int {
        let counts = roll.countPerDie().values
        if counts.contains(5) || (counts.contains(3) && counts.contains(2)) {
            return 25
        } else {
            return 0
        }
    }

    static func smallStraight(for roll: Roll) -> Int {
        if roll.hasSequence(ofLength: 4) {
            return 30
        } else {
            return 0
        }
    }

    static func largeStriaght(for roll: Roll) -> Int {
        if roll.hasSequence(ofLength: 5) {
            return 40
        } else {
            return 0
        }
    }

    static func yahtzee(for roll: Roll) -> Int {
        if roll.hasCountOfAKind(count: 5) {
            return 50
        } else {
            return 0
        }
    }

    static func chance(for roll: Roll) -> Int {
        return roll.sum()
    }
}
