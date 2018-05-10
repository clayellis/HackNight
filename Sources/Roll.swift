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

    func sum(of die: Die) -> Int {
        return dice.filter { $0 == die }.map { $0.rawValue }.reduce(+)
    }
}
