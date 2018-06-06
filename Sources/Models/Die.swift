//
//  Die.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/9/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import Foundation

/// The face value of a six-sided die.
enum Die: Int, CaseIterable {
    case one = 1, two, three, four, five, six
}

extension Die {

    /// - Returns: A random `Die`.
    static func random() -> Die {
        return Die.allCases.randomElement()!
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

extension Die: Comparable {
    static func < (lhs: Die, rhs: Die) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
