//
//  StackViewWrapper.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/17/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

final class StackViewWrapper: UIView {

    let stackView: UIStackView

    init(_ stackView: UIStackView) {
        self.stackView = stackView
        super.init(frame: .zero)
        addAutoLayoutSubview(stackView)
        stackView.fill(self, withPriority: .stackViewWrapping)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
