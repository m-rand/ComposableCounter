//
//  CounterListFeature.swift
//  ComposableCounter
//
//  Created by Marcel Balas on 07.09.2022.
//

import ComposableArchitecture
import Foundation

struct CounterList: ReducerProtocol {
    struct State: Equatable {
        var counters: IdentifiedArrayOf<Counter.State> = []
    }

    enum Action {
        case counter(id: Counter.State.ID, action: Counter.Action)
        case add
        case delete(id: Counter.State.ID)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .delete(id):
                state.counters.remove(id: id)
                return .none
            case .add:
                state.counters.append(Counter.State())
                return .none
            default:
                return .none
            }
        }.forEach(\.counters, action: /Action.counter(id:action:)) {
            Counter()
        }
    }
}
