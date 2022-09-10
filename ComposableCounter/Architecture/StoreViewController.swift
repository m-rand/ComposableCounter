//
//  StoreViewController.swift
//  ComposableTestApp
//
//  Created by Marcel Balas on 02.06.2022.
//

import Combine
import ComposableArchitecture
import UIKit

/// Convenience class for view controllers that are powered by state stores.
open class StoreViewController<State, Action>: UIViewController {

    // MARK: Properties

    /// The store powering the view controller.
    open var store: Store<State, Action>

    /// The view store wrapping the store for the actual view.
    open var viewStore: ViewStore<State, Action>

    /// Keeps track of subscriptions.
    open var cancellables: Set<AnyCancellable> = []


    // MARK: Initialization

    /// Creates a new store view controller with the given store.
    ///
    /// - Parameter store: The store to use with the view controller.
    ///
    /// - Returns: A new view controller.
    public init(store: Store<State, Action>) where State: Equatable {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
        configureStateObservation(on: viewStore)
    }

    public init(store: Store<State, Action>, removeDuplicates: @escaping (State, State) -> Bool) {
        self.store = store
        self.viewStore = ViewStore(store, removeDuplicates: removeDuplicates)
        super.init(nibName: nil, bundle: nil)
        configureStateObservation(on: viewStore)
    }

    @available(*, unavailable) public required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    // MARK: Subclass API

    /// Override this method to configure state observation.
    ///
    /// - Parameter viewStore: The view store to observe.
    open func configureStateObservation(on viewStore: ViewStore<State, Action>) { }
}
