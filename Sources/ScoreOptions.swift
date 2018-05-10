//
//  ScoreOptions.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/9/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import Foundation

// MARK: - Upper Section

enum ScoreOption {
    case ones, twos, threes, fours, fives, sixes,
    threeOfAKind, fourOfAKind, fullHouse,
    smallStraight, largeStriaght,
    yahtzee, chance

    func score(for roll: Roll) -> Int {
        switch self {

            // MARK: - Upper Section

        case .ones:
            return roll.sum(of: .one)

        case .twos:
            return roll.sum(of: .two)

        case .threes:
            return roll.sum(of: .three)

        case .fours:
            return roll.sum(of: .four)

        case .fives:
            return roll.sum(of: .five)

        case .sixes:
            return roll.sum(of: .six)

            // MARK: - Lower Section

        case .threeOfAKind:
            if roll.hasCountOfAKind(count: 3) {
                return roll.sum()
            } else {
                return 0
            }

        case .fourOfAKind:
            if roll.hasCountOfAKind(count: 4) {
                return roll.sum()
            } else {
                return 0
            }

        case .fullHouse:
            let counts = roll.countPerDie().values
            if counts.contains(5) || (counts.contains(3) && counts.contains(2)) {
                return 25
            } else {
                return 0
            }

        case .smallStraight:
            if roll.hasSequence(ofLength: 4) {
                return 30
            } else {
                return 0
            }

        case .largeStriaght:
            if roll.hasSequence(ofLength: 5) {
                return 40
            } else {
                return 0
            }

        case .yahtzee:
            if roll.hasCountOfAKind(count: 5) {
                return 50
            } else {
                return 0
            }

        case .chance:
            return roll.sum()

        }
    }
}

extension ScoreOption {
    static var all: [ScoreOption] {
        return [
            ones, twos, threes, fours, fives, sixes,
            threeOfAKind, fourOfAKind, fullHouse,
            smallStraight, largeStriaght,
            yahtzee, chance
        ]
    }

    static var upperSection: [ScoreOption] {
        return all.filter { $0.isUpperSection }
    }

    static var lowerSection: [ScoreOption] {
        return all.filter { $0.isLowerSection }
    }

    var isUpperSection: Bool {
        switch self {
        case .ones, .twos, .threes, .fours, .fives, .sixes:
            return true
        default:
            return false
        }
    }

    var isLowerSection: Bool {
        return !isUpperSection
    }
}
