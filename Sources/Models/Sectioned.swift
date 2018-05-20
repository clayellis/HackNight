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

    /// - Parameter section: The `Section` to match.
    /// - Returns: Whether this belongs to the given section.
    func belongsTo(section: Section) -> Bool
}
