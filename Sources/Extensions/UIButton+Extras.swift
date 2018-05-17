//
//  UIButton+Extras.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/17/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

extension UIButton {
    /// Set the button's background color for a control state
    public func setBackgroundColor(_ color: UIColor, forUIControlState state: UIControlState) {
        self.setBackgroundImage(UIImage(color: color), for: state)
    }

    /// Returns the background color used for a button state.
    /// - parameter state: The state that uses the background color. Possible values are described in UIControlState.
    /// - returns: The background color used for the specified state.
    public func backgroundColor(for state: UIControlState) -> UIColor? {
        let image = backgroundImage(for: state)
        return image?.color(at: .zero)
    }
}
