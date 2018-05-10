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

    func sum(of die: Die) -> Int {
        return dice.filter { $0 == die }.map { $0.rawValue }.reduce(0, +)
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
