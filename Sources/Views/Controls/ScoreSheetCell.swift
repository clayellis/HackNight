//
//  ScoreSheetCell.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/17/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

class ScoreSheetCell: UIView {

    fileprivate let stack = UIStackView()
    let titleLabel = UILabel()
    let scoreLabel = UILabel()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureSubviews()
        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSubviews() {
        backgroundColor = .white
        layer.cornerRadius = Styles.elementCornerRadius

        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true

        scoreLabel.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        scoreLabel.textAlignment = .center

        Styles.applyShadow(to: self)
    }

    private func configureLayout() {
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 10
        stack.layoutMargins = UIEdgeInsets(top: 15, left: 18, bottom: 15, right: 15)
        stack.isLayoutMarginsRelativeArrangement = true

        [titleLabel, scoreLabel].forEach(stack.addArrangedSubview)

        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        scoreLabel.setContentHuggingPriority(.required, for: .horizontal)

        addAutoLayoutSubview(stack)
        stack.fill(self, withPriority: .required)

        titleLabel.accessibilityIdentifier = "Title Label"
        scoreLabel.accessibilityIdentifier = "Score Label"
        stack.accessibilityIdentifier = "Score Cell Stack"
    }
}

final class ScoreOptionSheetCell: ScoreSheetCell {

    let scoreOption: ScoreOption

    init(scoreOption: ScoreOption) {
        self.scoreOption = scoreOption
        super.init(frame: .zero)
        titleLabel.text = scoreOption.description
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}









































