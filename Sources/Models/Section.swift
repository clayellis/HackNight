//
//  Section.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/20/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import Foundation

/// Types of sections.
enum Section: CaseIterable {

    /// The upper section type.
    case upper

    /// The lower section type.
    case lower
}

extension Section: Comparable {
    static func < (lhs: Section, rhs: Section) -> Bool {
        switch (lhs, rhs) {
        case (.upper, .lower): return true
        default: return false
        }
    }
}
