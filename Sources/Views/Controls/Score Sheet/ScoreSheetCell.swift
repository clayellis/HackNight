//
//  ScoreSheetCell.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/17/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

class ScoreSheetCell: UICollectionViewCell {

    var type: ScoreSheetCellType! {
        didSet {
            titleLabel.text = type.description
        }
    }

    fileprivate let stack = UIStackView()
    let titleLabel = UILabel()
    let scoreLabel = UILabel()

    var isEnabled: Bool = true {
        didSet {
            updateEnabledAppearance()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSubviews() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = Styles.elementCornerRadius

        let fontSize: CGFloat = 16

        titleLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true

        scoreLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        scoreLabel.textAlignment = .center

        Styles.applyShadow(to: contentView)
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

    private func updateEnabledAppearance() {
        isUserInteractionEnabled = isEnabled
        alpha = isEnabled ? 1 : 0.5
    }

    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }

        set {
            super.isHighlighted = newValue
            let highlighting = newValue
            contentView.backgroundColor = highlighting ? .lightGray : .white
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                if highlighting {
                    let scale: CGFloat = 0.985
                    self.transform = self.transform.scaledBy(x: scale, y: scale)
                } else {
                    self.transform = .identity
                }
            }, completion: nil)
        }
    }
}
