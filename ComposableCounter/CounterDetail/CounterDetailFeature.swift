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
#if compiler(>=5.5)
    case numberFactResponse(TaskResult<String>)
#else
    case numberFactResponse(Result<String, FactClient.Failure>)
#endif
}

struct NumbersApiError: Error, Equatable {}

struct CounterDetailEnvironment {
    var fact: FactClient
#if compiler(<5.5)
    var mainQueue: AnySchedulerOf<DispatchQueue>
#endif
}

let counterDetailReducer = Reducer<
    CounterDetailState, CounterDetailAction, CounterDetailEnvironment
> { state, action, environment in
    switch action {
    case let .onAppear(number):
        state.fact = nil
        // Return an effect that fetches a number fact from the API and returns the
        // value back to the reducer's `numberFactResponse` action.
#if compiler(>=5.5)
        return .task { [count = state.number] in
            await .numberFactResponse(TaskResult { try await environment.fact.fetch(count) })
        }
#else
        return environment.fact.fetchCombine(state.number)
            .receive(on: environment.mainQueue)
            .catchToEffect(CounterDetailAction.numberFactResponse)
#endif
    case let .numberFactResponse(.success(result)):
        state.fact = result
        return .none
    case .numberFactResponse(.failure):
        return .none
    }
}
