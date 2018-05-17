//
//  DiceView.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/16/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

/// A view for rendering a single dice.
final class DiceView: UIView {

    var dice: Die {
        didSet {
            configureDots()
        }
    }

    private enum DotPosition {
        case upperLeft
        case upperRight
        case lowerLeft
        case lowerRight
        case middle
        case middleLeft
        case middleRight

        static let all: Set<DotPosition> = [
            .upperLeft, .upperRight, .lowerLeft, .lowerRight, .middle, .middleLeft, .middleRight
        ]
    }

    private let dots: [DotPosition: DotView] = {
        let keysValues = zip(
            DotPosition.all,
            DotPosition.all.map { _ in DotView() }
        )
        return Dictionary(uniqueKeysWithValues: keysValues)
    }()

    init(dice: Die, frame: CGRect = .zero) {
        self.dice = dice
        super.init(frame: frame)
        configureAppearance()
        configureLayout()
        configureDots()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureAppearance() {
        backgroundColor = .white
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
    }

    private func configureLayout() {
        layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        var constraints = [NSLayoutConstraint]()

        for (position, dotView) in dots {
            addSubview(dotView)
            dotView.translatesAutoresizingMaskIntoConstraints = false

            switch position {
            case .upperLeft:
                constraints.append(dotView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor))
                constraints.append(dotView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor))

            case .upperRight:
                constraints.append(dotView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor))
                constraints.append(dotView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor))

            case .middleLeft:
                constraints.append(dotView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor))
                constraints.append(dotView.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor))

            case .middleRight:
                constraints.append(dotView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor))
                constraints.append(dotView.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor))

            case .lowerLeft:
                constraints.append(dotView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor))
                constraints.append(dotView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor))

            case .lowerRight:
                constraints.append(dotView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor))
                constraints.append(dotView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor))

            case .middle:
                constraints.append(dotView.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor))
                constraints.append(dotView.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor))
            }
        }

        NSLayoutConstraint.activate(constraints)
    }

    private func configureDots() {
        switch dice {
        case .one:
            showDots(at: .middle)

        case .two:
            showDots(at: .lowerLeft, .upperRight)

        case .three:
            showDots(at: .lowerLeft, .middle, .upperRight)

        case .four:
            showDots(at: .upperLeft, .upperRight, .lowerLeft, .lowerRight)

        case .five:
            showDots(at: .upperLeft, .upperRight, .middle, .lowerLeft, .lowerRight)

        case .six:
            showDots(at: .upperLeft, .upperRight, .middleLeft, .middleRight, .lowerLeft, .lowerRight)
        }
    }

    private func showDots(at positions: Set<DotPosition>) {
        // Show the provided dots
        positions
            .compactMap { dots[$0] }
            .forEach { $0.isHidden = false }

        // Hide the others
        DotPosition.all.subtracting(positions)
            .compactMap { dots[$0] }
            .forEach { $0.isHidden = true }
    }

    private func showDots(at positions: DotPosition...) {
        showDots(at: Set(positions))
    }

    override var intrinsicContentSize: CGSize {
        let size: CGFloat = 50
        return CGSize(width: size, height: size)
    }
}

private class DotView: UIView {
    private let radius: CGFloat

    init(radius: CGFloat = 8) {
        self.radius = radius
        super.init(frame: .zero)
        backgroundColor = .black
        layer.cornerRadius = radius / 2
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: radius, height: radius)
    }
}
