//
//  Die.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/9/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import Foundation

/// The face value of a six-sided die.
enum Die: Int {
    case one = 1, two, three, four, five, six
}

extension Die {

    /// All possible values of `Die`.
    static let all: Set<Die> = [.one, .two, .three, .four, .five, .six]
}

extension Die {

    /// - Returns: A randome `Die`.
    static func random() -> Die {
        let rand = Int(arc4random_uniform(UInt32(all.count))) + 1
        return Die(rawValue: rand)!
    }
}

extension Die {

    /// - Returns: The corresponding upper section score option.
    var correspondingUpperSectionScoreOption: ScoreOption {
        switch self {
        case .one: return .ones
        case .two: return .twos
        case .three: return .threes
        case .four: return .fours
        case .five: return .fives
        case .six: return .sixes
        }
    }
}
