//
//  Int+Extras.swift
//  Yahtzee
//
//  Created by Clay Ellis on 6/6/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import Foundation

extension Int {
    var isEven: Bool {
        return self % 2 == 0
    }

    var isOdd: Bool {
        return !isEven
    }
}
