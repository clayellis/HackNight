//
//  ScoreOptions.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/9/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import Foundation

class UpperSectionScoreOption: ScoreOption {
    let roll: Roll
    let die: Die

    init(roll: Roll, die: Die) {
        self.roll = roll
        self.die = die
    }

    func score() -> Int {
        return roll.sum(of: die)

    }
}

final class Ones: UpperSectionScoreOption {
    init(roll: Roll) {
        super.init(roll: roll, die: .one)
    }
}
