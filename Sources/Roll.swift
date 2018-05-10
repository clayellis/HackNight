//
//  Roll.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/9/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import Foundation

struct Roll {
    let dice: [Die]

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
}

extension Array where Element == Die {
    func sum() -> Int {
        return self.map { $0.rawValue }.reduce(0, +)
    }
}
