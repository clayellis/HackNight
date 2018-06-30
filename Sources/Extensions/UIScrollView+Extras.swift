//
//  UIScrollView+Extras.swift
//  Yahtzee
//
//  Created by Clay Ellis on 6/30/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

extension UIScrollView {
    func forceDelaysContentTouches(_ shouldForce: Bool) {
        delaysContentTouches = shouldForce
        for scrollView in subviewsWithClassType(UIScrollView.self) {
            scrollView.delaysContentTouches = shouldForce
        }
    }
}
