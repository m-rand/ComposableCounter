//
//  StoreControl.swift
//  ComposableTestApp
//
//  Created by Marcel Balas on 02.06.2022.
//

import Combine
import ComposableArchitecture
import UIKit

/// The state store cell is a UIControl superclass designed to work with Composable Architecture state stores.
/// It removes much of the boiler plate involved with creating a custom control subclass.
open class StoreControl<State, Action>: UIControl {

    // MARK: Properties

    /// Any current store for this control.
    public var store: Store<State, Action>

    /// Any current view store for this control.
    public var viewStore: ViewStore<State, Action>

    /// A place to store cancallables for state subscriptions.
    public var cancellables: Set<AnyCancellable> = []

    // MARK: Initialization

    /// Create a new state store control with the given store.
    ///
    /// - Parameter store: The store that manages the state.
    ///
    /// - Returns: A new state store control
    public init(store: Store<State, Action>) where State: Equatable {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(frame: .zero)
        configureControl()
        configureStateObservation(on: viewStore)
    }

    @available(*, unavailable) public required init?(coder: NSCoder) { fatalError() }

    // MARK: Subclass API

    /// Override this method to configure state observation.
    ///
    /// - Parameter viewStore: The view store to observe.
    open func configureStateObservation(on viewStore: ViewStore<State, Action>) { }

    /// Override this method to setup views when a cell is created.
    open func configureControl() { }

}
