//
//  UILayoutPriority+Extras.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/17/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

extension UILayoutPriority {

    /// A priority that will avoid layout warnings when embedding stack views. (`999`).
    static let stackViewWrapping = UILayoutPriority(UILayoutPriority.required.rawValue - 1)
}
