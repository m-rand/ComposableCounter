//
//  CounterFeature.swift
//  ComposableCounter
//
//  Created by Marcel Balas on 07.09.2022.
//

import ComposableArchitecture
import Foundation

struct CounterState: Equatable, Identifiable {
    let id = UUID()
    var count = 0
}

enum CounterAction: Equatable {
    case decrementButtonTapped
    case incrementButtonTapped
}

struct CounterEnvironment {}

let counterReducer = Reducer<CounterState, CounterAction, CounterEnvironment> { state, action, _ in
    switch action {
    case .decrementButtonTapped:
        state.count -= 1
        return .none
    case .incrementButtonTapped:
        state.count += 1
        return .none
    }
}
