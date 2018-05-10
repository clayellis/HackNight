//
//  Roll.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/9/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import Foundation

struct Roll {
    enum Error: Swift.Error {
        case invalidNumberOfDice(Int)
    }

    static let DICE_COUNT = 5
    let dice: [Die]

    init(dice: [Die]) throws {
        guard dice.count == Roll.DICE_COUNT else {
            throw Error.invalidNumberOfDice(dice.count)
        }

        self.dice = dice
    }

    init(_ ints: Int...) throws {
        let dice = ints.compactMap { Die(rawValue: $0) }
        try self.init(dice: dice)
    }

    static func roll(presets: [Int : Die] = [:]) -> Roll {
        var dice: [Die] = []
        for i in 0..<DICE_COUNT {
            if let presetDie = presets[i] {
                dice.append(presetDie)
            } else {
                dice.append(Die.random())
            }
        }

        return try! Roll(dice: dice)
    }

    // MARK: Sum

    func sum(of die: Die) -> Int {
        return dice.filter { $0 == die }.sum()
    }

    func sum() -> Int {
        return dice.sum()
    }

    // MARK: Counts

    func countPerDie() -> [Die: Int] {
        var counts = [Die: Int]()
        for die in dice {
            counts[die, default: 0] += 1
        }
        return counts
    }

    func count(of die: Die) -> Int {
        return countPerDie()[die] ?? 0
    }

    func hasCount(_ count: Int, of die: Die) -> Bool {
        return self.count(of: die) >= count
    }

    func hasCountOfAKind(count: Int) -> Bool {
        return countPerDie().first { $0.value >= count } != nil
    }

    // MARK: Sequence Length

    func hasSequence(ofLength length: Int) -> Bool {
        let ordered = dice.map { $0.rawValue }.sorted()

        var lower = 0
        var upper: Int {
            return lower + length
        }

        while upper <= Die.all.count {
            let range = Array(ordered.suffix(from: lower))
            if range == Array(lower...upper) {
                return true
            }
        }

        return false
    }
}

extension Array where Element == Die {
    func sum() -> Int {
        return self.map { $0.rawValue }.reduce(0, +)
    }
}
