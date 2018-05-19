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
    func focus(on scoreOption: ScoreOption)
    func removeFocus()

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

    private enum GameState {
        case startGame
        case startTurn
        case rollOne
        case rollTwo
        case rollThree
        case noRollsLeft
        case chooseScoreOption
        case finishedGame
    }

    private var state = GameState.startGame {
        didSet {
            handleStateChange(state)
        }
    }

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
            // TODO: Determine how to display the bonus to the user
        }
    }

    private func hasScore(for scoreOption: ScoreOption) -> Bool {
        return scores[scoreOption] != nil
    }
}

// MARK: - State Changes

private extension GameViewModel {

    private func handleStateChange(_ newState: GameState) {
        print("Game Entered State: \(newState)")

        switch newState {
        case .startGame:
            scores = [:]
            currentSelections = []
            currentRoll = nil

            // Move the game forward to the start turn state
            state = .startTurn

        case .startTurn:
            currentSelections = []
            currentRoll = nil
            delegate?.enableRollButton(true)

            // Move the game forward to the first roll
            state = .rollOne

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
            delegate?.removeFocus()
            if isComplete() {
                state = .finishedGame
            } else {
                state = .startTurn
            }

        case .finishedGame:
            let finalScore = calculateGrandTotalScore()
            delegate?.presentFinalScore(finalScore)
            print("Final Score: \(finalScore)")
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
        // Kick off state tracking
//        state = .startGame
        handleStateChange(state)
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

        switch state {
        case .rollOne:
            state = .rollTwo

        case .rollTwo:
            state = .rollThree

        case .rollThree:
            state = .noRollsLeft

        default:
            break
        }

        let roll = currentRoll!

        // If the roll was a yahtzee, and yahtzee has already been chosen...
        if roll.isYahtzee, hasScore(for: .yahtzee) {
            // ... increment the yahtzee bonus count
            yahtzeeBonusCount += 1

            // The corresponding upper section score option must be chosen if it hasn't already been filled
            let correspondingOption = roll.dice[0].correspondingUpperSectionScoreOption
            if !hasScore(for: correspondingOption) {
                delegate?.focus(on: correspondingOption)
            }
        } else {
            delegate?.removeFocus()
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

        guard scores[scoreOption] == nil else {
            return
        }

        scores[scoreOption] = scoreOption.score(for: roll)
        state = .chooseScoreOption
    }

    func handleNewGameTapped() {
        state = .startGame
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
