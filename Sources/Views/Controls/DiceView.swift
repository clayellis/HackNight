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

    var dice: Die? {
        didSet {
            setNeedsDisplay()
        }
    }

    var isSelected = false {
        didSet {
            updateSelectedAppearance()
        }
    }

    override var intrinsicContentSize: CGSize {
        let size: CGFloat = 50
        return CGSize(width: size, height: size)
    }

    private enum DotPosition: CaseIterable {
        case upperLeft
        case upperRight
        case lowerLeft
        case lowerRight
        case middle
        case middleLeft
        case middleRight

        enum Row {
            case upper
            case middle
            case lower
        }

        var row: Row {
            switch self {
            case .upperLeft, .upperRight:
                return .upper
            case .middleLeft, .middle, .middleRight:
                return .middle
            case .lowerLeft, .lowerRight:
                return .lower
            }
        }

        enum Column {
            case left
            case middle
            case right
        }

        var column: Column {
            switch self {
            case .upperLeft, .middleLeft, .lowerLeft:
                return .left
            case .middle:
                return .middle
            case .upperRight, .middleRight, .lowerRight:
                return .right
            }
        }

        static func positions(for dice: Die) -> Set<DotPosition> {
            switch dice {
            case .one:
                return [.middle]

            case .two:
                return [.lowerLeft, .upperRight]

            case .three:
                return [.lowerLeft, .middle, .upperRight]

            case .four:
                return [.upperLeft, .upperRight, .lowerLeft, .lowerRight]

            case .five:
                return [.upperLeft, .upperRight, .middle, .lowerLeft, .lowerRight]

            case .six:
                return [.upperLeft, .upperRight, .middleLeft, .middleRight, .lowerLeft, .lowerRight]
            }
        }
    }

    init(dice: Die?) {
        self.dice = dice
        super.init(frame: .zero)
        configureAppearance()
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

    private func updateSelectedAppearance() {
        layer.borderColor = isSelected ? Styles.selectionBlue.cgColor : UIColor.lightGray.cgColor
        layer.borderWidth = isSelected ? 3 : 1
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), let dice = dice else {
            return
        }

        // This fill color will be used by the dots
        context.setFillColor(UIColor.black.cgColor)

        let paddedRect = rect.inset(by: UIEdgeInsets(allEdges: rect.height * 0.15))
        let spacing = paddedRect.height * 0.08
        let dH = (paddedRect.height + spacing * 2) / 3
        let dW = (paddedRect.width + spacing * 2) / 3

        for position in DotPosition.positions(for: dice) {
            let top: CGFloat
            let bottom: CGFloat
            switch position.row {
            case .upper:
                top = 0
                bottom = dH * 2
            case .middle:
                top = dH
                bottom = dH
            case .lower:
                top = dH * 2
                bottom = 0
            }

            let left: CGFloat
            let right: CGFloat
            switch position.column {
            case .left:
                left = 0
                right = dW * 2
            case .middle:
                left = dW
                right = dW
            case .right:
                left = dW * 2
                right = 0
            }

            var rect = paddedRect.inset(by: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))

            // Ensure that the rect is a square
            rect.size.width = rect.size.height

            context.fillEllipse(in: rect)
        }
    }
}
