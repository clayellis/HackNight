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
    static let all: [Die] = [.one, .two, .three, .four, .five, .six]
}

extension Die {

    /// - returns: A randome `Die`.
    static func random() -> Die {
        let rand = Int(arc4random_uniform(UInt32(all.count)))
        return Die(rawValue: rand)!
    }
}
