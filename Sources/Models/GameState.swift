//
//  GameState.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/17/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import Foundation

/// The states that a game can be in.
enum GameState: State {
    case startGame
    case startTurn
    case rollOne
    case rollTwo
    case rollThree
    case noRollsLeft
    case chooseScoreOption
    case finishedGame

    static let initialState = GameState.startGame
}

final class GameStateMachine: StateMachine<GameState> {
    init() {
        super.init(transitionsDictionary: [
            .startGame: [.startTurn],
            .startTurn: [.rollOne],
            .rollOne: [.rollTwo, .chooseScoreOption],
            .rollTwo: [.rollThree, .chooseScoreOption],
            .rollThree: [.noRollsLeft, .chooseScoreOption],
            .noRollsLeft: [.chooseScoreOption],
            .chooseScoreOption: [.startTurn, .finishedGame],
            .finishedGame: [.startGame]
            ])
    }
}
