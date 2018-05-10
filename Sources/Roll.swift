//
//  Roll.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/9/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import Foundation

private let DICE_COUNT = 5

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

	static func roll(presets: [Int : Die] = [:]) -> Roll {
		var dice: [Die] = []
		for i in 0..<DICE_COUNT {
			if let presetDie = presets[i] {
				dice.append(presetDie)
			} else {
				dice.append(Die.random())
			}
		}

		return Roll(dice: dice)
	}
}
