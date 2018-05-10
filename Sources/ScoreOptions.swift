//
//  ScoreOptions.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/9/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import Foundation

// MARK: - Upper Section

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

final class Twos: UpperSectionScoreOption {
	init(roll: Roll) {
		super.init(roll: roll, die: .two)
	}
}

final class Threes: UpperSectionScoreOption {
	init(roll: Roll) {
		super.init(roll: roll, die: .three)
	}
}

final class Fours: UpperSectionScoreOption {
	init(roll: Roll) {
		super.init(roll: roll, die: .four)
	}
}

final class Fives: UpperSectionScoreOption {
	init(roll: Roll) {
		super.init(roll: roll, die: .five)
	}
}

final class Sixes: UpperSectionScoreOption {
	init(roll: Roll) {
		super.init(roll: roll, die: .six)
	}
}
// MARK: - Lower Section

class OfAKindOption: ScoreOption {
    let roll: Roll
    let requiredCount: Int

    init(roll: Roll, requiredCount: Int) {
        self.roll = roll
        self.requiredCount = requiredCount
    }

    func score() -> Int {
        if roll.hasCountOfAKind(count: requiredCount) {
            return roll.sum()
        } else {
            return 0
        }
    }
}

final class ThreeOfAKindOption: OfAKindOption {
    init(roll: Roll) {
        super.init(roll: roll, requiredCount: 3)
    }
}

final class FourOfAKindOption: OfAKindOption {
    init(roll: Roll) {
        super.init(roll: roll, requiredCount: 4)
    }
}

final class FullHouseOption: ScoreOption {
    let roll: Roll

    init(roll: Roll) {
        self.roll = roll
    }

    func score() -> Int {
        let counts = roll.countPerDie().values
        if counts.contains(5) || (counts.contains(3) && counts.contains(2)) {
            return 25
        } else {
            return 0
        }
    }
}

//class StraightOption: ScoreOption {
//    let roll: Roll
//    let minimumSequenceLength: Int
//
//    init(roll: Roll, minimumSequenceLength: Int) {
//        self.roll = roll
//        self.minimumSequenceLength = minimumSequenceLength
//    }
//
//    func score() -> Int {
//        let ordered = roll.dice.map { $0.rawValue }.sorted()
//        var lower = 0
//        var currentRange = Array(lower...)
//        Array(0...3)
//    }
//}

