//
//  Array+Sum.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/14/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import Foundation

extension Array where Element == Die {

    /// - Returns: The sum of all dice in the array.
    func sum() -> Int {
        return self.map { $0.rawValue }.reduce(0, +)
    }
}
