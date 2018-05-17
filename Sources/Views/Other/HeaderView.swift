//
//  HeaderViewController.swift
//  Yahtzee
//
//  Created by Danny Harding on 5/9/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    let label = UILabel()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        label.text = "Yahtzee"
        label.textAlignment = .center
        label.font = label.font.withSize(30)

        addAutoLayoutSubview(label)

        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalTo: self.widthAnchor),
            label.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -20),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
