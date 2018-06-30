//
//  UIEdgeInsets+Extras.swift
//  Yahtzee
//
//  Created by Clay Ellis on 6/5/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    var vertical: CGFloat {
        get {
            return top + bottom
        }

        set {
            top = vertical
            bottom = vertical
        }
    }

    var horizontal: CGFloat {
        get {
            return left + right
        }

        set {
            left = horizontal
            right = horizontal
        }
    }

    init(allEdges inset: CGFloat) {
        self.init(top: inset, left: inset, bottom: inset, right: inset)
    }
}
