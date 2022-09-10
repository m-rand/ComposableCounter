//
//  StoreCell.swift
//  ComposableTestApp
//
//  Created by Marcel Balas on 02.06.2022.
//

import Combine
import ComposableArchitecture
import UIKit

/// The state store cell is a cell superclass designed to work with Composable Architecture state stores. It removes
/// much of the boiler plate involved with creating a custom cell subclass.
open class StoreCell<State, Action>: UICollectionViewCell {

    // MARK: Properties

    /// Any current store for this cell.
    public var store: Store<State, Action>?

    /// Any current view store for this cell.
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

    /// Configure the cell with the given store for equatable state.
    ///
    /// - Parameter store: The store to use for the cell.
    public func configure(with store: Store<State, Action>) where State: Equatable {
        let viewStore = ViewStore(store)
        self.store = store
        self.viewStore = viewStore
        configureStateObservation(on: viewStore)
    }

    /// Configure the cell with the given store and providing `removeDuplicates` function.
    ///
    /// - Parameter store: The store to use for the cell.
    public func configure(with store: Store<State, Action>, removeDuplicates: @escaping (State, State) -> Bool) {
        let viewStore = ViewStore(store, removeDuplicates: removeDuplicates)
        self.store = store
        self.viewStore = viewStore
        configureStateObservation(on: viewStore)
    }

    // MARK: Cell Lifecycle

    open override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
        store = nil
        viewStore = nil
    }

    // MARK: Subclass API

    /// Override this method to configure state observation whenever the cell is configured with a new store.
    ///
    /// - Parameter viewStore: The view store that was created as part of the configuration.
    open func configureStateObservation(on viewStore: ViewStore<State, Action>) {}

    /// Override this method to setup views when a cell is created.
    open func setupViews() {}

}
