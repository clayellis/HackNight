//
//  Sectioned.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/20/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import Foundation

/// Represents an object that can belong to an upper or lower section.
protocol Sectioned {

    /// Whether this belongs to the upper section.
    var isInUpperSection: Bool { get }

    /// Whether this belongs to the lower section.
    var isInLowerSection: Bool { get }
}

// MARK: - Default Implementations

extension Sectioned {

    var isInLowerSection: Bool {
        return !isInUpperSection
    }
}
