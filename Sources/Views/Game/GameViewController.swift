//
//  GameViewController.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/17/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

final class GameViewController: UIViewController {

    let gameView = GameView()
    let viewModel: GameViewModeling

    init(viewModel: GameViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = gameView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        gameView.rollView.delegate = self
        configureCells()
        configureButtons()
    }

    private func configureCells() {
        for cell in gameView.scoreSheet.cells.values {
            cell.scoreLabel.text = 0.description
        }
    }

    private func configureButtons() {
        gameView.rollButton.setTitle(viewModel.rollButtonTitle, for: .normal)
        gameView.rollButton.addTarget(self, action: #selector(rollTapped), for: .touchUpInside)
    }

    @objc private func rollTapped() {
        viewModel.handleRollTapped()
    }

}

extension GameViewController: RollViewDelegate {
    func rollView(_ rollView: RollView, didChangeSelectionsFrom from: Set<Int>, to: Set<Int>) {
        viewModel.handleSelectionsChange(from: from, to: to)
    }
}

extension GameViewController: GameViewModelDelegate {
    func rollDidChange(to newRoll: Roll?) {
        gameView.rollView.roll = newRoll
    }
}
