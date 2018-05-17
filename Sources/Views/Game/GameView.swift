//
//  GameView.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/17/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

final class GameView: UIView {

    let rollView = RollView()
    let rollButton = UIButton()

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
        backgroundColor = .lightGray

        rollButton.clipsToBounds = true
        rollButton.layer.cornerRadius = 10
        rollButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        rollButton.setBackgroundColor(.black, forUIControlState: .normal)
        rollButton.setBackgroundColor(UIColor.black.withAlphaComponent(0.8), forUIControlState: .highlighted)
    }

    private func configureLayout() {
        addSubview(bottomStack)
        bottomStack.translatesAutoresizingMaskIntoConstraints = false

        bottomStack.axis = .vertical
        bottomStack.alignment = .fill
        bottomStack.distribution = .fillProportionally
        bottomStack.spacing = 15
        bottomStack.isLayoutMarginsRelativeArrangement = true
        bottomStack.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        rollButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)

        bottomStack.addArrangedSubview(rollView)
        bottomStack.addArrangedSubview(rollButton)

        NSLayoutConstraint.activate([
            bottomStack.leftAnchor.constraint(equalTo: leftAnchor),
            bottomStack.rightAnchor.constraint(equalTo: rightAnchor),
            bottomStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            ])
    }
}
