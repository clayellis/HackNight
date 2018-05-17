//
//  Game.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/10/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import Foundation

struct Game {
    typealias Scores = [ScoreOption: Int]

    var scores: Scores
//    var currentTurn: Turn

    // NOTE: Maximum number of bonuses is 4
    var yahtzeeBonusCount: Int {
        didSet {
            if yahtzeeBonusCount > 4 {
                yahtzeeBonusCount = 4
            }
        }
    }

    func calculateUpperSectionScore() -> Int {
        var total = scores
            .filter { $0.key.isUpperSection }
            .map { $0.value }
            .reduce(0, +)
        if total > 63 {
            total += 35
        }
        return total
    }

    func calculateLowerSectionScore() -> Int {
        var total = scores
            .filter { $0.key.isLowerSection }
            .map { $0.value }
            .reduce(0, +)
        let yahtzeeBonusScore = min(yahtzeeBonusCount, 4) * 100
        total += yahtzeeBonusScore
        return total
    }

    func calculateGrandTotalScore() -> Int {
        let upper = calculateUpperSectionScore()
        let lower = calculateLowerSectionScore()
        return upper + lower
    }

    func isComplete() -> Bool {
        // A game is copmlete once there is a score for each score option
        return scores.values.count == ScoreOption.all.count
    }
}

//extension Game {
//    init() {
//        self.init(scores: [:], currentTurn: Game.Turn())
//    }
//}
//
//extension Game {
//    struct Turn {
//        var currentRollNumber: RollNumber
//    }
//}
//
//extension Game.Turn {
//    init() {
//        self.init(currentRollNumber: .first)
//    }
//}
//
//extension Game.Turn {
//    enum RollNumber {
//        case first, second, third
//    }
//}
