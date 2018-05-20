//
//  ScoreOptions.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/9/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import Foundation

// MARK: - Upper Section

enum ScoreOption: Int {

    /// The sum of all ones in the roll.
    ///
    /// - Note: If the roll was 1, 1, 2, 3, 4
    /// the score would be 2.
    case ones

    /// The sum of all twos in the roll.
    ///
    /// - Note: If the roll was 1, 1, 2, 2, 3
    /// the score would be 4.
    case twos

    /// The sum of all threes in the roll.
    ///
    /// - Note: If the roll was 3, 3, 2, 1, 3
    /// the score would be 9.
    case threes

    /// The sum of all fours in the roll.
    ///
    /// - Note: If the roll was 4, 3, 2, 4, 3
    /// the score would be 8.
    case fours

    /// The sum of all fives in the roll.
    ///
    /// - Note: If the roll was 4, 5, 5, 4, 5
    /// the score would be 15.
    case fives

    /// The sum of all sixes in the roll.
    ///
    /// - Note: If the roll was 6, 3, 2, 4, 6
    /// the score would be 12.
    case sixes

    /// The sum of the roll if there are at least three of the
    /// same kind of dice, otherwise zero.
    ///
    /// - Note: If the roll was 1, 1, 1, 2, 3
    /// the score would be 8.
    ///
    /// If the roll was 1, 2, 3, 4, 5
    /// the score would be 0.
    case threeOfAKind

    /// The sum of the roll if there are at least four of the
    /// same kind of dice, otherwise zero.
    ///
    /// - Note: If the roll was 1, 1, 1, 1, 2
    /// the score would be 6.
    ///
    /// If the roll was 1, 2, 3, 4, 5
    /// the score would be 0.
    case fourOfAKind

    /// 25 points if the roll contains at least three of the same
    /// kind of dice and two of the same kind of dice, otherwise zero.
    /// (Five of a kind is also valid.)
    ///
    /// - Note: If the roll was 1, 1, 1, 2, 2
    /// the score would be 25.
    ///
    /// If the roll was 1, 2, 3, 4, 5
    /// the score would be 0.
    case fullHouse

    /// 30 points if the roll contains a sequence with a length of at
    /// least 4, otherwise zero.
    ///
    /// - Note: If the roll was 1, 2, 3, 4, 2
    /// the score would be 30.
    ///
    /// If the roll was 1, 2, 3, 2, 1
    /// the score would be 0.
    case smallStraight

    /// 40 points if the roll contains a sequence with a length of at
    /// least 5, otherwize zero.
    ///
    /// - Note: If the roll was 1, 2, 3, 4, 5
    /// the score would be 40.
    ///
    /// If the roll was 1, 2, 3, 2, 1
    /// the score would be 0.
    case largeStriaght

    /// 50 points if all five dice are the same, otherwize zero.
    ///
    /// - Note: If the roll was 5, 5, 5, 5, 5
    /// the score would be 50.
    ///
    /// If the roll was 1, 2, 3, 2, 1
    /// the score would be 0.
    case yahtzee

    /// The sum of the roll.
    ///
    /// - Note: If the roll was 1, 2, 3, 4, 5
    /// the score would be 15.
    case chance
}

// MARK: - Scoring

extension ScoreOption {

    /// - Parameter roll: The `roll` whose scroll will be computed.
    /// - Returns: The score for the `roll` using this `ScoreOption`.
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
            if roll.isYahtzee {
                return 50
            } else {
                return 0
            }

        case .chance:
            return roll.sum()

        }
    }
}

// MARK: - Sections

extension ScoreOption: Sectioned {

    /// All possible values of `ScoreOption`.
    static let all: Set<ScoreOption> = [
        ones, twos, threes, fours, fives, sixes,
        threeOfAKind, fourOfAKind, fullHouse,
        smallStraight, largeStriaght,
        yahtzee, chance
    ]

    /// All `ScoreOption`s belonging to the upper section.
    static let upperSection: Set<ScoreOption> = {
        return all.filter { $0.isInUpperSection }
    }()

    /// All `ScoreOption`s belonging to the lower section.
    static let lowerSection: Set<ScoreOption> = {
        return all.filter { $0.isInLowerSection }
    }()

    var isInUpperSection: Bool {
        switch self {
        case .ones, .twos, .threes, .fours, .fives, .sixes:
            return true
        default:
            return false
        }
    }
}

// MARK: - Comparable

extension ScoreOption: Comparable {
    static func < (lhs: ScoreOption, rhs: ScoreOption) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

// MARK: - Description

extension ScoreOption: CustomStringConvertible {

    var description: String {
        switch self {
        case .ones: return "Ones"
        case .twos: return "Twos"
        case .threes: return "Threes"
        case .fours: return "Fours"
        case .fives: return "Fives"
        case .sixes: return "Sixes"
        case .threeOfAKind: return "Three of a Kind"
        case .fourOfAKind: return "Four of a Kind"
        case .fullHouse: return "Full House"
        case .smallStraight: return "Small Straight"
        case .largeStriaght: return "Large Straight"
        case .yahtzee: return "Yahtzee"
        case .chance: return "Chance"
        }
    }
}
