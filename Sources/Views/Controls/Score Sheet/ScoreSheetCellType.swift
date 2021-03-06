//
//  ScoreSheetCellType.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/20/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import Foundation

/// Types of score sheet cells.
enum ScoreSheetCellType: Hashable {

    /// A type that represents a `ScoreOption` cell.
    case scoreOption(ScoreOption)

    /// A type that represents the upper section bonus cell.
    case upperSectionBonus

    /// A type that represents the grand total cell.
    case grandTotal
}

extension ScoreSheetCellType: Sectioned {

    func belongsTo(section: Section) -> Bool {
        switch (self, section) {
        case (.scoreOption(let option), _):
            return option.belongsTo(section: section)

        case (.upperSectionBonus, .upper):
            return true

        case (.grandTotal, .lower):
            return true

        default:
            return false
        }
    }
}

extension ScoreSheetCellType: CustomStringConvertible {

    var description: String {
        switch self {
        case .scoreOption(let option):
            return option.description

        case .upperSectionBonus:
            return "Bonus"

        case .grandTotal:
            return "Total"
        }
    }
}

extension ScoreSheetCellType: Comparable {
    static func < (lhs: ScoreSheetCellType, rhs: ScoreSheetCellType) -> Bool {
        switch (lhs, rhs) {
        case (.scoreOption(let lhsOption), .scoreOption(let rhsOption)):
            return lhsOption < rhsOption

        // Upper section options come before the bonus,
        // but the bonus comes before lower section
        case (.scoreOption(let option), .upperSectionBonus):
            return option.belongsTo(section: .upper)

        case (.upperSectionBonus, .scoreOption(let option)):
            return option.belongsTo(section: .lower)

        // The grand total comes after all others
        case (.grandTotal, _):
            return false

        case (_, .grandTotal):
            return true

        // Match bonus against itself (there will only be one, though.)
        case (.upperSectionBonus, .upperSectionBonus):
            return true
        }
    }
}
