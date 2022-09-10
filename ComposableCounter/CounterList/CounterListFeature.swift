//
//  CounterListFeature.swift
//  ComposableCounter
//
//  Created by Marcel Balas on 07.09.2022.
//

import ComposableArchitecture
import Foundation

struct CounterListState: Equatable {
    var counters: IdentifiedArrayOf<CounterState> = []
}

enum CounterListAction: Equatable {
    case counter(id: CounterState.ID, action: CounterAction)
    case add
    case delete(id: CounterState.ID)
}

struct CounterListEnvironment {
    var numberFact: FactClient
}

let counterListReducer: Reducer<CounterListState, CounterListAction, CounterListEnvironment> = .combine(
    Reducer { state, action, env in
        switch action {
        case let .delete(id):
            state.counters.remove(id: id)
            return .none
        case .add:
            state.counters.append(CounterState())
            return .none
        default:
            return .none
        }
    },
    counterReducer.forEach(
        state: \.counters,
        action: /CounterListAction.counter(id:action:),
        environment: { _ in CounterEnvironment() }
    )
)
