//
//  Styles.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/17/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

struct Styles {
    private init() {}

    static let elementCornerRadius: CGFloat = 15

    static let lightBackground = UIColor(hex: "F2F2F2")

    static let selectionBlue = UIColor(hex: "187AED")

    static func applyShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.10
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
}
