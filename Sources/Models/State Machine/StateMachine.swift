//
//  StateMachine.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/17/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import Foundation

protocol State: Hashable {
    static var initialState: Self { get }
}

struct StateTransition<S: State>: Hashable {
    let from: S
    let to: S
}

class StateMachine<S: State> {

    typealias StateChangeHandler = (S) -> Void

    private(set) var state = S.initialState {
        didSet {
            stateChangeHandler?(state)
        }
    }

    private var stateChangeHandler: StateChangeHandler?

    private var transitions = Set<StateTransition<S>>()

    init(transitions: Set<StateTransition<S>> = []) {
        self.transitions = transitions
    }

    init(transitionsDictionary: [S: Set<S>]) {
        let transitions = transitionsDictionary
            .map { key, value in
                value.map { StateTransition(from: key, to: $0) }
            }
            .flatMap { $0 }
        self.transitions = Set(transitions)
    }

    func addTransition(from: S, to: S) {
        let transition = StateTransition(from: from, to: to)
        transitions.insert(transition)
    }

    func addTransitions(from: S, to states: Set<S>) {
        let transitions = states.map { StateTransition(from: from, to: $0) }
        for transition in transitions {
            self.transitions.insert(transition)
        }
    }

    func addTransitions(from: S, to states: S...) {
        addTransitions(from: from, to: Set(states))
    }

    func setState(to newState: S) throws {
        let proposedTransition = StateTransition(from: state, to: newState)
        guard transitions.contains(proposedTransition) else {
            throw Error.invalidStateTransition(from: state, to: newState)
        }

        state = newState
    }

    func onStateChange(use handler: StateChangeHandler?) {
        stateChangeHandler = handler
        handler?(state)
    }
}

extension StateMachine {
    /// Errors that can occur inside the state machine.
    enum Error: LocalizedError {

        /// Indicates that a state transition was invalid.
        /// Contains the "from" state and the "to" state.
        case invalidStateTransition(from: S, to: S)

        var errorDescription: String? {
            switch self {
            case .invalidStateTransition(let from, let to):
                return "Invalid transition from \(from) to \(to)."
            }
        }
    }
}
