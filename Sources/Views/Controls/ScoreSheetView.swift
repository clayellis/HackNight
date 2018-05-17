//
//  ScoreSheetView.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/17/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

final class ScoreSheetView: UIView {

    private let columnsStack = UIStackView()
    private let leftColumn = UIStackView()
    private let rightColumn = UIStackView()

    let cells: [ScoreOption: ScoreSheetCell] = {
        let keysValues = ScoreOption.all.map { ($0, ScoreOptionSheetCell(scoreOption: $0)) }
        return Dictionary(uniqueKeysWithValues: keysValues)
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureSubviews()
        configureLayout()
        configureCells()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSubviews() {

    }

    private func configureLayout() {
        columnsStack.axis = .horizontal
        columnsStack.alignment = .fill
        columnsStack.distribution = .fillEqually
        columnsStack.spacing = 10

        [leftColumn, rightColumn].forEach {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.spacing = 10

            let wrapper = StackViewWrapper($0)
            wrapper.accessibilityIdentifier = "Column Wrapper"
            columnsStack.addArrangedSubview(wrapper)
        }

        addAutoLayoutSubview(columnsStack)
        columnsStack.fill(self, withPriority: .stackViewWrapping)

        columnsStack.accessibilityIdentifier = "Columns Stack"
        leftColumn.accessibilityIdentifier = "Left Column Stack"
        rightColumn.accessibilityIdentifier = "Right Column Stack"
    }

    private func configureCells() {
        for (option, cell) in cells.sorted(by: { $0.key < $1.key }) {

            if option.isUpperSection {
                leftColumn.addArrangedSubview(cell)
            } else {
                rightColumn.addArrangedSubview(cell)
            }

            cell.accessibilityIdentifier = "Score Cell (\(option.description))"
        }
    }
}
