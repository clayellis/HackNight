//
//  Die.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/9/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import Foundation

enum Die: Int {
    case one = 1, two, three, four, five, six

    static var all: [Die] = [.one, .two, .three, .four, .five, .six]

    private static let count: Die.RawValue = {
        var nextValue: Int = 0
        while let _ = Die(rawValue: nextValue) {
            nextValue += 1
        }
        return nextValue
    }()

    static func random() -> Die {
        let rand = Int(arc4random_uniform(UInt32(count)))
        return Die(rawValue: rand)!
    }
}

extension Die: ExpressibleByIntegerLiteral {
    typealias IntegerLiteralType = Int

    init(integerLiteral value: IntegerLiteralType) {
        self.init(rawValue: value)!
    }
}
