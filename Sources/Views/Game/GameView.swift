//
//  GameView.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/17/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

final class GameView: UIView {

    let scoreSheet = ScoreSheetView()
    let rollView = RollView()
    let rollButton = UIButton()

    private let contentStack = UIStackView()
    private let bottomStack = UIStackView()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureSubviews()
        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSubviews() {
        backgroundColor = Styles.lightBackground

        rollButton.clipsToBounds = true
        rollButton.layer.cornerRadius = Styles.elementCornerRadius
        rollButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        rollButton.setBackgroundColor(.black, forUIControlState: .normal)
        rollButton.setBackgroundColor(UIColor.black.withAlphaComponent(0.8), forUIControlState: .highlighted)

        [rollView, rollButton].forEach(Styles.applyShadow)
    }

    private func configureLayout() {
        rollButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)

        contentStack.axis = .vertical
        contentStack.alignment = .fill
        contentStack.distribution = .fillProportionally
        contentStack.spacing = 20
        contentStack.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        contentStack.isLayoutMarginsRelativeArrangement = true

        let bottomWrapper = StackViewWrapper(bottomStack)
        bottomWrapper.accessibilityIdentifier = "Bottom Stack Wrapper"

        contentStack.addArrangedSubview(scoreSheet)
        contentStack.addArrangedSubview(bottomWrapper)

        bottomStack.axis = .vertical
        bottomStack.alignment = .fill
        bottomStack.distribution = .fillProportionally
        bottomStack.spacing = 15
        bottomStack.addArrangedSubview(rollView)
        bottomStack.addArrangedSubview(rollButton)

        addAutoLayoutSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.leftAnchor.constraint(equalTo: leftAnchor),
            contentStack.rightAnchor.constraint(equalTo: rightAnchor),
            contentStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            ])

        contentStack.accessibilityIdentifier = "Content Stack"
        bottomStack.accessibilityIdentifier = "Bottom Stack"
        scoreSheet.accessibilityIdentifier = "Score Sheet"
        rollView.accessibilityIdentifier = "Roll View"
        rollButton.accessibilityIdentifier = "Roll Button"
    }
}
