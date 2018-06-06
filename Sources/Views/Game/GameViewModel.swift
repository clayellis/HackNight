//
//  GameViewModel.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/17/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import Foundation

enum GameState {
    case startGame
    case startTurn
    case rollOne
    case rollTwo
    case rollThree
    case noRollsLeft
    case chooseScoreOption
    case finishedGame
}

protocol GameViewModelDelegate: class {
    func rollDidChange(to newRoll: Roll?)
    func selectionsDidChange(to selections: Set<Int>)
    func updateRollButtonTitle(to newTitle: String)
    func enableRollButton(_ shouldEnable: Bool)
    func enableRollSelections(_ shouldEnable: Bool)
    func refreshScoreOptions()
    func focus(on scoreOptions: Set<ScoreOption>)
    func removeFocus()

    func presentFinalScore(_ score: Int)
}

protocol GameViewModeling: class {
    var delegate: GameViewModelDelegate? { get set }

    var title: String { get }
    var newGameButtonTitle: String { get }
    var canSelectDice: Bool { get }
    var isRollButtonEnabled: Bool { get }
    var rollButtonTitle: String { get }

    func scoreText(forType type: ScoreSheetCellType) -> String?

    func handleViewDidAppear()
    func handleRollTapped()
    func handleSelection(at index: Int)
    func handleScoreSheetCellTapped(ofType type: ScoreSheetCellType)
    func handleNewGameTapped()
}

class GameViewModel: GameViewModeling {

    weak var delegate: GameViewModelDelegate?

    var title: String {
        return "Yahtzee"
    }

    var newGameButtonTitle: String {
        return "New Game"
    }

    var state = GameState.startGame {
        didSet {
            handleStateChange(state)
        }
    }

    var scores = [ScoreOption: Int]() {
        didSet {
            delegate?.refreshScoreOptions()
        }
    }

    var currentRoll: Roll? {
        didSet {
            delegate?.rollDidChange(to: currentRoll)
        }
    }

    var currentSelections = Set<Int>() {
        didSet {
            delegate?.selectionsDidChange(to: currentSelections)
        }
    }

    var canSelectDice: Bool = false {
        didSet {
            delegate?.enableRollSelections(canSelectDice)
        }
    }

    var yahtzeeBonusCount: Int = 0 {
        didSet {
            // TODO: Determine how to display the bonus to the user
        }
    }

    var currentEnabledOptions: Set<ScoreOption> = Set(ScoreOption.allCases) {
        didSet {
            if currentEnabledOptions == Set(ScoreOption.allCases) {
                delegate?.removeFocus()
            } else {
                delegate?.focus(on: currentEnabledOptions)
            }
        }
    }

    var isRollButtonEnabled: Bool = true {
        didSet {
            delegate?.enableRollButton(isRollButtonEnabled)
        }
    }

    var rollButtonTitle: String = "Roll" {
        didSet {
            delegate?.updateRollButtonTitle(to: rollButtonTitle)
        }
    }

    var finalScore: Int? {
        didSet {
            if let score = finalScore {
                delegate?.presentFinalScore(score)
            }
        }
    }

    func hasScore(for scoreOption: ScoreOption) -> Bool {
        return scores[scoreOption] != nil
    }

    func scoreText(forType type: ScoreSheetCellType) -> String? {
        switch type {
        case .scoreOption(let option):
            return scores[option]?.description

        case .upperSectionBonus:
            let score = calculateUpperSectionRawScore()
            if score >= Constants.upperSectionBonusThreshold {
                return Constants.upperSectionBonus.description
            } else {
                return "\(score)/\(Constants.upperSectionBonusThreshold)"
            }

        case .grandTotal:
            return calculateGrandTotalScore().description
        }
    }
}

// MARK: - State Changes

private extension GameViewModel {

    private func handleStateChange(_ newState: GameState) {
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
            isRollButtonEnabled = true

            // Move the game forward to the first roll
            state = .rollOne

        case .rollOne:
            rollButtonTitle = "Roll (3)"

        case .rollTwo:
            canSelectDice = true
            rollButtonTitle = "Roll (2)"

        case .rollThree:
            rollButtonTitle = "Roll (1)"

        case .noRollsLeft:
            rollButtonTitle = "Choose Score Option"
            isRollButtonEnabled = false

        case .chooseScoreOption:
            currentEnabledOptions = Set(ScoreOption.allCases)
            if isComplete() {
                state = .finishedGame
            } else {
                state = .startTurn
            }

        case .finishedGame:
            finalScore = calculateGrandTotalScore()
        }
    }
}

// MARK: - Game Scores

private extension GameViewModel {

    func calculateUpperSectionRawScore() -> Int {
        return scores
            .filter { $0.key.belongsTo(section: .upper) }
            .map { $0.value }
            .reduce(0, +)
    }

    func calculateUpperSectionScore() -> Int {
        var score = calculateUpperSectionRawScore()
        if score >= Constants.upperSectionBonusThreshold {
            score += Constants.upperSectionBonus
        }
        return score
    }

    func calculateLowerSectionScore() -> Int {
        var total = scores
            .filter { $0.key.belongsTo(section: .lower) }
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
        return scores.values.count == Set(ScoreOption.allCases).count
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
                currentEnabledOptions = [correspondingOption]
            }
        } else {
            currentEnabledOptions = Set(ScoreOption.allCases)
        }
    }

    func handleSelection(at index: Int) {
        if currentSelections.contains(index) {
            currentSelections.remove(index)
        } else {
            currentSelections.insert(index)
        }
    }

    func handleScoreSheetCellTapped(ofType type: ScoreSheetCellType) {
        guard case let .scoreOption(scoreOption) = type else {
            return
        }

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

extension GameViewModel {

    struct Constants {
        private init() {}

        static let upperSectionBonusThreshold = 63

        static let upperSectionBonus = 35
    }
}
