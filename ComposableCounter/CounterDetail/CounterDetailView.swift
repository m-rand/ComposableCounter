//
//  CounterDetailView.swift
//  ComposableCounter
//
//  Created by Marcel Balas on 09.09.2022.
//

import ComposableArchitecture
import SwiftUI

struct CounterDetailView: View {
    let store: Store<CounterDetailState, CounterDetailAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(alignment: .center, spacing: 8) {
                Text("\(viewStore.number)")
                    .font(.title2)
                if viewStore.fact == nil {
                    ProgressView()
                        .foregroundColor(.red)
                } else {
                    Text(viewStore.fact ?? "")
                        .font(.title3)
                }
                Spacer()
            }
            .padding()
            .onAppear {
                viewStore.send(.onAppear(viewStore.number))
            }
        }
    }
}

struct CounterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CounterDetailView(
            store: Store(
                initialState: CounterDetailState(number: 4),
                reducer: counterDetailReducer,
                environment: CounterDetailEnvironment(
                    fact: .live
                )
            )
        )
    }
}
