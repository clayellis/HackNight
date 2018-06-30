//
//  Roll.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/9/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import Foundation


// TODO: Write tests for Roll


/// Represents a roll in the game.
struct Roll {

    /// The dice which this roll contains.
    let dice: [Die]

    /// Creates a new `Roll` using optional presets.
    ///
    /// - Parameter presets: A dictionary of `Die` presets where `key` is the position of the preset,
    ///     and `value` is the `Die` at the preset position.
    /// - Returns: A new `Roll` using the `presets` if present, otherwise an entirely random `Roll`.
    init(presets: [Int: Die] = [:]) {
        if presets.isEmpty {
            self.dice = (0 ..< Constants.requiredDiceCount).map { _ in Die.random() }
        } else {
            self.dice = (0 ..< Constants.requiredDiceCount).map { presets[$0] ?? Die.random() }
        }
    }

    /// Creates a new `Roll` from a list of `Int`s.
    ///
    /// - Parameter ints: A list of integers that represent individual `Dice`.
    /// - Throws: If `ints` contained too many or too few values, or if a value was invalid.
    /// - Returns: A new `Roll` using the list of integers.
    init(_ ints: Int...) throws {
        guard ints.count == Constants.requiredDiceCount else {
            throw Error.invalidNumberOfDice(ints.count)
        }

        self.dice = try ints.map {
            guard let dice = Die(rawValue: $0) else {
                throw Error.invalidDiceValue($0)
            }

            return dice
        }
    }
}

// MARK: - Re-roll

extension Roll {

    /// Creates a new `Roll`, optionally saving the dice at the given positions.
    ///
    /// - Parameter positions: The positions of the dice that should not be re-rolled.
    /// - Throws: If any of the positions were invalid.
    /// - Returns: A new `Roll`, optionally saving the dice at the given positions.
    func reroll(savingDiceAt positions: Set<Int> = []) throws -> Roll {
        var presets = [Int: Die]()
        for position in positions {
            guard dice.indices.contains(position) else {
                throw Error.invalidPosition(position)
            }

            presets[position] = dice[position]
        }

        return Roll(presets: presets)
    }

    /// See: `Roll.reroll(savingDiceAt:)`
    func reroll(savingDiceAt positions: Int...) throws -> Roll {
        return try reroll(savingDiceAt: Set(positions))
    }
}

// MARK: - Sum

extension Roll {

    /// - Parameter die: The `Die` that should be summed.
    /// - Returns: The sum of the provided `die` in the roll.
    func sum(of die: Die) -> Int {
        return dice.filter { $0 == die }.sum()
    }

    /// - Returns: The sum of all dice in the roll.
    func sum() -> Int {
        return dice.sum()
    }
}

// MARK: - Counts

extension Roll {

    /// - Returns: A dictionary where `key` is a `Die` and `value` is
    ///     the count of that `Die` in the roll.
    func countPerDie() -> [Die: Int] {
        let defaults = zip(Die.allCases, Array(repeating: 0, count: Die.allCases.count))
        var counts = Dictionary(uniqueKeysWithValues: defaults)
        for die in dice {
            counts[die, default: 0] += 1
        }
        return counts
    }

    /// - Parameter die: The `Die` that should be counted.
    /// - Returns: The count of the provided `die` in the roll.
    func count(of die: Die) -> Int {
        return countPerDie()[die] ?? 0
    }

    /// - Parameters:
    ///     - count: The required count to satisfy the condition.
    ///     - die: The `Die` that should be counted.
    /// - Returns: Whether the roll has at least `count` many `die`.
    func hasCount(_ count: Int, of die: Die) -> Bool {
        return self.count(of: die) >= count
    }

    /// - Parameter count: The required count to satisfy the condition.
    /// - Returns: Whether the roll has at least `count` many of
    ///     same type of any `Die`.
    func hasCountOfAKind(count: Int) -> Bool {
        return countPerDie().first { $0.value >= count } != nil
    }
}

// MARK: - Sequence Length

extension Roll {

    /// - Parameter length: The required length to satisfy the condition.
    /// - Returns: Whether the roll has a numerical sequence of `Die`
    ///     with a length of at least `lenth`.
    func hasSequence(ofLength length: Int) -> Bool {
        let ordered = Set(dice.map { $0.rawValue }).sorted()
        var currentSequenceLength = 1
        for (index, current) in ordered.enumerated() {
            guard ordered.indices.contains(index + 1) else {
                break
            }

            let next = ordered[index + 1]
            if next - current == 1 {
                currentSequenceLength += 1
            } else {
                currentSequenceLength = 1
            }

            if currentSequenceLength == length {
                return true
            }
        }

        return false
    }
}

// MARK: - Yahtzee

extension Roll {

    /// - Returns: Whether the roll is a yahtzee.
    var isYahtzee: Bool {
        return hasCountOfAKind(count: Constants.requiredDiceCount)
    }

}

// MARK: - Errors

extension Roll {

    /// Errors that can occur while creating a `Roll`.
    enum Error: LocalizedError {

        /// Indicates that an invalid number of dice was used.
        /// Contains the invalid number.
        case invalidNumberOfDice(Int)

        /// Indicates that an invalid dice value was used.
        /// Contains the invalid value.
        case invalidDiceValue(Int)

        /// Indicates that an invalid position was used.
        /// Contains the invalid position.
        case invalidPosition(Int)

        var errorDescription: String? {
            switch self {
            case .invalidNumberOfDice(let count):
                return "Invalid number of dice: \(count)"

            case .invalidDiceValue(let value):
                return "Invalid dice value: \(value)"

            case .invalidPosition(let position):
                return "Invalid position: \(position)"
            }
        }
    }
}

// MARK: - Constants

extension Roll {

    /// Internal constants.
    struct Constants {
        private init() {}

        /// The number of dice required in a roll.
        static let requiredDiceCount = 5
    }
}
