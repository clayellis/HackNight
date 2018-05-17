//
//  DiceViewController.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/16/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

/// A view controller that displays all dice in a vertical stack.
class DiceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing

        Die.all
            .sorted { $0.rawValue < $1.rawValue }
            .map { DiceView(dice: $0) }
            .forEach(stack.addArrangedSubview)

        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.leftAnchor.constraint(equalTo: view.leftAnchor),
            stack.rightAnchor.constraint(equalTo: view.rightAnchor),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
    }
}
