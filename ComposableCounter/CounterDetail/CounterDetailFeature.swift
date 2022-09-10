//
//  CounterDetailFeature.swift
//  ComposableCounter
//
//  Created by Marcel Balas on 09.09.2022.
//

import ComposableArchitecture
import Foundation

struct CounterDetailState: Equatable {
    var number: Int
    var fact: String?
}

enum CounterDetailAction: Equatable {
    case onAppear(Int)
    case numberFactResponse(TaskResult<String>)
}

struct NumbersApiError: Error, Equatable {}

struct CounterDetailEnvironment {
    var fact: FactClient
}

let counterDetailReducer = Reducer<
    CounterDetailState, CounterDetailAction, CounterDetailEnvironment
> { state, action, environment in
    switch action {
    case let .onAppear(number):
        state.fact = nil
        // Return an effect that fetches a number fact from the API and returns the
        // value back to the reducer's `numberFactResponse` action.
        return .task { [count = state.number] in
            await .numberFactResponse(TaskResult { try await environment.fact.fetchAsync(count) })
        }
    case let .numberFactResponse(.success(result)):
        state.fact = result
        return .none
    case .numberFactResponse(.failure(_)):
        return .none
    }
}
