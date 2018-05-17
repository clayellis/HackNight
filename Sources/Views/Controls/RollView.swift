//
//  RollView.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/17/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

protocol RollViewDelegate: class {
    func rollView(_ rollView: RollView, didChangeSelectionsFrom from: Set<Int>, to: Set<Int>)
}

/// A view that represents a roll.
final class RollView: UIView {

    weak var delegate: RollViewDelegate?

    var roll: Roll? {
        didSet {
            configureDice(with: roll)
        }
    }

    private let stackView = UIStackView()
    private lazy var diceViews: [DiceView] = {
        if let roll = roll {
            return roll.dice.map(DiceView.init)
        } else {
            // This isn't working for some reason. Only one DiceView gets created.
//            let result = [0 ..< Roll.Constants.requiredDiceCount].map { _ in
//                DiceView(dice: nil)
//            }
            var results = [DiceView]()
            for _ in 0 ..< Roll.Constants.requiredDiceCount {
                results.append(DiceView(dice: nil))
            }
            return results
        }
    }()

    private var selectedDiceViews: Set<DiceView> {
        return Set(diceViews.filter { $0.isSelected })
    }

    var selectedPositions: Set<Int> {
        return Set(selectedDiceViews.compactMap { diceViews.index(of: $0) })
    }

    var selectedDice: Set<Die> {
        return Set(selectedDiceViews.compactMap { $0.dice })
    }

    init(roll: Roll? = nil) {
        self.roll = roll
        super.init(frame: .zero)
        configureSubviews()
        configureLayout()
        configureGestureRecognizers()
        configureDice(with: roll)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSubviews() {
        backgroundColor = .white
        layer.cornerRadius = 10
    }

    private func configureLayout() {
        layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        diceViews.forEach(stackView.addArrangedSubview)

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
            ])
    }

    private func configureGestureRecognizers() {
        diceViews.forEach {
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedDice(gesture:))))
        }
    }

    private func configureDice(with roll: Roll?) {
        diceViews.forEach { $0.isUserInteractionEnabled = roll != nil }

        if let roll = roll {
            zip(roll.dice, diceViews).forEach { dice, diceView in
                diceView.dice = dice
            }
        }
    }

    @objc private func tappedDice(gesture: UITapGestureRecognizer) {
        guard let diceView = gesture.view as? DiceView else {
            return
        }

        let oldSelections = selectedPositions
        diceView.isSelected = !diceView.isSelected

        delegate?.rollView(self, didChangeSelectionsFrom: oldSelections, to: selectedPositions)
    }
}
