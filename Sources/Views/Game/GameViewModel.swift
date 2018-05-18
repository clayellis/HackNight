//
//  GameViewModel.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/17/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import Foundation

protocol GameViewModelDelegate: class {
    func rollDidChange(to newRoll: Roll?)
    func selectionsDidChange(to selections: Set<Int>)
    func updateRollButtonTitle(to newTitle: String)
    func enableRollButton(_ shouldEnable: Bool)
    func enableRollSelections(_ shouldEnable: Bool)
    func refreshScoreOptions()

    func presentFinalScore(_ score: Int)
}

protocol GameViewModeling: class {
    var delegate: GameViewModelDelegate? { get set }

    var title: String { get }
    var initialRollButtonTitle: String { get }
    func scoreText(for option: ScoreOption) -> String?

    func handleViewDidAppear()
    func handleRollTapped()
    func handleSelection(at index: Int)
    func handleScoreOptionTapped(scoreOption: ScoreOption)
    func handleNewGameTapped()
}

class GameViewModel: GameViewModeling {

    weak var delegate: GameViewModelDelegate?

    private var scores = [ScoreOption: Int]() {
        didSet {
            delegate?.refreshScoreOptions()
        }
    }

    private var currentRoll: Roll? {
        didSet {
            delegate?.rollDidChange(to: currentRoll)
        }
    }

    private var currentSelections = Set<Int>() {
        didSet {
            delegate?.selectionsDidChange(to: currentSelections)
        }
    }

    private var yahtzeeBonusCount: Int = 0 {
        didSet {
            if yahtzeeBonusCount > 4 {
                yahtzeeBonusCount = 4
            }
        }
    }

    private let stateMachine = GameStateMachine()
}

// MARK: - State Changes

private extension GameViewModel {

    func handleStateChange(_ newState: GameState) {
        print("Game Entered State: \(newState)")

        do {
            switch newState {
            case .startGame:
                scores = [:]
                currentSelections = []
                currentRoll = nil

                // Move the game forward to the start turn state
                try stateMachine.setState(to: .startTurn)

            case .startTurn:
                currentSelections = []
                currentRoll = nil
                delegate?.enableRollButton(true)

                // Move the game forward to the first roll
                try stateMachine.setState(to: .rollOne)

            case .rollOne:
                delegate?.updateRollButtonTitle(to: "Roll (3)")

            case .rollTwo:
                delegate?.enableRollSelections(true)
                delegate?.updateRollButtonTitle(to: "Roll (2)")

            case .rollThree:
                delegate?.updateRollButtonTitle(to: "Roll (1)")

            case .noRollsLeft:
                delegate?.updateRollButtonTitle(to: "Choose Score Option")
                delegate?.enableRollButton(false)

            case .chooseScoreOption:
                if isComplete() {
                    try stateMachine.setState(to: .finishedGame)
                } else {
                    try stateMachine.setState(to: .startTurn)
                }

            case .finishedGame:
                let finalScore = calculateGrandTotalScore()
                delegate?.presentFinalScore(finalScore)
                print("Final Score: \(finalScore)")
            }

        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Game Scores

private extension GameViewModel {

    func calculateUpperSectionScore() -> Int {
        var total = scores
            .filter { $0.key.isUpperSection }
            .map { $0.value }
            .reduce(0, +)
        if total > 63 {
            total += 35
        }
        return total
    }

    func calculateLowerSectionScore() -> Int {
        var total = scores
            .filter { $0.key.isLowerSection }
            .map { $0.value }
            .reduce(0, +)
        let yahtzeeBonusScore = min(yahtzeeBonusCount, 4) * 100
        total += yahtzeeBonusScore
        return total
    }

    func calculateGrandTotalScore() -> Int {
        let upper = calculateUpperSectionScore()
        let lower = calculateLowerSectionScore()
        return upper + lower
    }

    func isComplete() -> Bool {
        // A game is copmlete once there is a score for each score option
        return scores.values.count == ScoreOption.all.count
    }
}

// MARK: - View Actions

extension GameViewModel {

    func handleViewDidAppear() {
        stateMachine.onStateChange(use: handleStateChange)
    }

    func handleRollTapped() {
        if let current = currentRoll {
            do {
                currentRoll = try current.reroll(savingDiceAt: currentSelections)
            } catch {
                print(error.localizedDescription)
                return
            }
        } else {
            currentRoll = Roll()
        }

        do {
            switch stateMachine.state {
            case .rollOne:
                try stateMachine.setState(to: .rollTwo)

            case .rollTwo:
                try stateMachine.setState(to: .rollThree)

            case .rollThree:
                try stateMachine.setState(to: .noRollsLeft)

            default:
                break
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func handleSelection(at index: Int) {
        if currentSelections.contains(index) {
            currentSelections.remove(index)
        } else {
            currentSelections.insert(index)
        }
    }
    
    func handleScoreOptionTapped(scoreOption: ScoreOption) {
        guard let roll = currentRoll else {
            return
        }

        do {
            scores[scoreOption] = scoreOption.score(for: roll)
            try stateMachine.setState(to: .chooseScoreOption)
        } catch {
            print(error.localizedDescription)
        }
    }

    func handleNewGameTapped() {
        do {
            try stateMachine.setState(to: .startGame)
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - View Data

extension GameViewModel {

    var title: String {
        return "Yahtzee"
    }

    var initialRollButtonTitle: String {
        return "Roll"
    }

    func scoreText(for option: ScoreOption) -> String? {
        return scores[option]?.description ?? " "
    }
}
