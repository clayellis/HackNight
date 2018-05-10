//
//  ScoreOption.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/9/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import Foundation

protocol ScoreOption {
    var roll: Roll { get }
    func score() -> Int
}
