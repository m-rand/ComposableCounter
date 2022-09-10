//
//  StoreCollectionReusableView.swift
//  ComposableTestApp
//
//  Created by Marcel Balas on 02.06.2022.
//

import Combine
import ComposableArchitecture
import UIKit

/// The state store reusable view is a superclass designed to work with Composable Architecture state stores. It removes
/// much of the boiler plate involved with creating a custom collection view reusable view subclass.
open class StoreCollectionReusableView<State, Action>: UICollectionReusableView {

    // MARK: Properties

    /// Any current store for this reusable view.
    public var store: Store<State, Action>?

    /// Any current view store for this reusable view.
    public var viewStore: ViewStore<State, Action>?

    /// A place to store cancallables for state subscriptions.
    public var cancellables: Set<AnyCancellable> = []

    // MARK: Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable) public required init?(coder: NSCoder) { fatalError() }

    // MARK: Configuration

    /// Configure the reusable view with the given store.
    ///
    /// - Parameter store: The store to use for the reusable view.
    public func configure(with store: Store<State, Action>) where State: Equatable {
        let viewStore = ViewStore(store)
        self.store = store
        self.viewStore = viewStore
        configureStateObservation(on: viewStore)
    }

    // MARK: Reusable View Lifecycle

    open override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
        store = nil
        viewStore = nil
    }

    // MARK: Subclass API

    /// Override this method to configure state observation whenever the view is configured with a new store.
    ///
    /// - Parameter viewStore: The view store that was created as part of the configuration.
    open func configureStateObservation(on viewStore: ViewStore<State, Action>) { }

    /// Override this method to setup views when a view is created.
    open func setupViews() { }

}
