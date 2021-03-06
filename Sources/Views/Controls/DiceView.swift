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

        /// - Parameter x: The side length of the entire dice view.
        /// - Returns: The diameter of a single dot given a side length.
        func d(of x: CGFloat) -> CGFloat {
            return (x + spacing * 2) / 3
        }


        let dH = d(of: paddedRect.height)
        let dW = d(of: paddedRect.width)

        for position in DotPosition.positions(for: dice) {
            let top: CGFloat
            let bottom: CGFloat
            switch position.row {
            case .top:
                top = 0
                bottom = dH * 2
            case .middle:
                top = dH
                bottom = dH
            case .bottom:
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

private extension DiceView {

    enum DotPosition: CaseIterable {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
        case middle
        case middleLeft
        case middleRight

        enum Row {
            case top
            case middle
            case bottom
        }

        var row: Row {
            switch self {
            case .topLeft, .topRight:
                return .top
            case .middleLeft, .middle, .middleRight:
                return .middle
            case .bottomLeft, .bottomRight:
                return .bottom
            }
        }

        enum Column {
            case left
            case middle
            case right
        }

        var column: Column {
            switch self {
            case .topLeft, .middleLeft, .bottomLeft:
                return .left
            case .middle:
                return .middle
            case .topRight, .middleRight, .bottomRight:
                return .right
            }
        }

        static func positions(for dice: Die) -> Set<DotPosition> {
            switch dice {
            case .one:
                return [.middle]

            case .two:
                return [.bottomLeft, .topRight]

            case .three:
                return [.bottomLeft, .middle, .topRight]

            case .four:
                return [.topLeft, .topRight, .bottomLeft, .bottomRight]

            case .five:
                return [.topLeft, .topRight, .middle, .bottomLeft, .bottomRight]

            case .six:
                return [.topLeft, .topRight, .middleLeft, .middleRight, .bottomLeft, .bottomRight]
            }
        }
    }
}
