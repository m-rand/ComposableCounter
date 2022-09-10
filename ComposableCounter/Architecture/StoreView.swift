//
//  StoreView.swift
//  ComposableTestApp
//
//  Created by Marcel Balas on 02.06.2022.
//

import Combine
import ComposableArchitecture
import UIKit

/// Convenience class for views that are powered by state stores.
open class StoreView<State, Action>: UIView {

    // MARK: Properties

    /// The store powering the view.
    open var store: Store<State, Action>

    /// The view store wrapping the store for the view.
    open var viewStore: ViewStore<State, Action>

    /// Keeps track of subscriptions.
    open var cancellables: Set<AnyCancellable> = []

    // MARK: Initialization

    /// Creates a new store view with the given store.
    ///
    /// - Parameter frame: The initial frame of the view.
    /// - Parameter store: The store to use with the view.
    ///
    /// - Returns: A new view controller.
    public init(frame: CGRect = .zero, store: Store<State, Action>) where State: Equatable {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(frame: frame)
        configureView()
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

    /// Override this method to setup views when a cell is created.
    open func configureView() { }

}
