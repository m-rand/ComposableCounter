//
//  CounterDetailFeature.swift
//  ComposableCounter
//
//  Created by Marcel Balas on 09.09.2022.
//

import ComposableArchitecture
import Foundation

struct CounterDetail: ReducerProtocol {
    struct State: Equatable {
        var number: Int
        var fact: String?
    }

    enum Action {
        case onAppear
        case numberFactResponse(TaskResult<String>)
    }

    @Dependency(\.factClient) var factClient

    func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
        switch action {
        case .onAppear:
            state.fact = nil
            // Return an effect that fetches a number fact from the API and returns the
            // value back to the reducer's `numberFactResponse` action.
            return .task { [count = state.number] in
                await .numberFactResponse(TaskResult { try await self.factClient.fetch(count) })
            }
       case let .numberFactResponse(.success(result)):
            state.fact = result
            return .none
        case .numberFactResponse(.failure):
            return .none
        }
    }
}
