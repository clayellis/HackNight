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
        configureDelegates()
        configureCells()
        configureButtons()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.handleViewDidAppear()
    }

    private func configureDelegates() {
        viewModel.delegate = self
        gameView.rollView.delegate = self
        gameView.scoreSheet.delegate = self
    }

    private func configureCells() {
//        for cell in gameView.scoreSheet.cells.values {
//            cell.scoreLabel.text = 0.description
//        }
    }

    private func configureButtons() {
        gameView.rollButton.setTitle(viewModel.initialRollButtonTitle, for: .normal)
        gameView.rollButton.addTarget(self, action: #selector(rollTapped), for: .touchUpInside)
    }

    @objc private func rollTapped() {
        viewModel.handleRollTapped()
    }

}

extension GameViewController: GameViewModelDelegate {
    func rollDidChange(to newRoll: Roll?) {
        gameView.rollView.roll = newRoll
    }

    func selectionsDidChange(to selections: Set<Int>) {
        gameView.rollView.selectDice(at: selections)
    }

    func updateRollButtonTitle(to newTitle: String) {
        gameView.rollButton.setTitle(newTitle, for: .normal)
    }

    func enableRollButton(_ shouldEnable: Bool) {
        gameView.rollButton.isEnabled = shouldEnable
    }

    func enableRollSelections(_ shouldEnable: Bool) {
        gameView.rollView.isUserInteractionEnabled = shouldEnable
    }

    func refreshScoreOptions() {
        for (option, cell) in gameView.scoreSheet.cells {
            cell.scoreLabel.text = viewModel.scoreText(for: option)
        }
    }

    func focus(on scoreOption: ScoreOption) {
        gameView.scoreSheet.focus(on: [scoreOption])
    }

    func removeFocus() {
        gameView.scoreSheet.focus(on: ScoreOption.all)
    }

    func presentFinalScore(_ score: Int) {
        let alert = UIAlertController(title: "Game Over", message: "Final Score: \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "New Game", style: .default) { _ in
            self.viewModel.handleNewGameTapped()
        })
        present(alert, animated: true, completion: nil)
    }
}

extension GameViewController: RollViewDelegate {
    func rollView(_ rollView: RollView, didSelectDiceAt index: Int) {
        viewModel.handleSelection(at: index)
    }
}

extension GameViewController: ScoreSheetDelegate {
    func scoreSheet(_ scoreSheet: ScoreSheetView, didSelect cell: ScoreSheetCell, with scoreOption: ScoreOption) {
        viewModel.handleScoreOptionTapped(scoreOption: scoreOption)
    }
}
