//
//  RollView.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/17/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

protocol RollViewDelegate: class {
    func rollView(_ rollView: RollView, didSelectDiceAt index: Int)
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
        layer.cornerRadius = Styles.elementCornerRadius
    }

    private func configureLayout() {
        layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        diceViews.forEach(stackView.addArrangedSubview)

        addAutoLayoutSubview(stackView)
        stackView.fill(layoutMarginsGuide, withPriority: .stackViewWrapping)
    }

    private func configureGestureRecognizers() {
        diceViews.forEach {
            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedDice(gesture:))))
        }
    }

    private func configureDice(with roll: Roll?) {
        if let roll = roll {
            zip(roll.dice, diceViews).forEach { dice, diceView in
                diceView.dice = dice
            }
        } else {
            diceViews.forEach {
                $0.dice = nil
            }
        }
    }

    @objc private func tappedDice(gesture: UITapGestureRecognizer) {
        guard let diceView = gesture.view as? DiceView else {
            return
        }

        guard let index = diceViews.index(of: diceView) else {
            return
        }

        delegate?.rollView(self, didSelectDiceAt: index)
    }

    func selectDice(at positions: Set<Int>) {
        for (index, diceView) in diceViews.enumerated() {
            diceView.isSelected = positions.contains(index)
        }
    }
}
