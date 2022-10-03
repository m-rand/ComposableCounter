//
//  CounterFeature.swift
//  ComposableCounter
//
//  Created by Marcel Balas on 07.09.2022.
//

import ComposableArchitecture
import Foundation

struct Counter: ReducerProtocol {
    struct State: Equatable, Identifiable {
        let id = UUID()
        var count = 0
    }

    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .decrementButtonTapped:
            state.count -= 1
            return .none
        case .incrementButtonTapped:
            state.count += 1
            return .none
        }
    }
}
