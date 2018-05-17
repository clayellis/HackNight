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
}

protocol GameViewModeling: class {
    var delegate: GameViewModelDelegate? { get set }
    var rollButtonTitle: String { get }
    func handleRollTapped()
    func handleSelectionsChange(from: Set<Int>, to: Set<Int>)
}

class GameViewModel: GameViewModeling {

    weak var delegate: GameViewModelDelegate?

    var currentRoll: Roll?

    var currentSelections = Set<Int>()

    var rollButtonTitle: String {
        return "Roll"
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

        delegate?.rollDidChange(to: currentRoll)
    }

    func handleSelectionsChange(from: Set<Int>, to: Set<Int>) {
        currentSelections = to
    }
}
