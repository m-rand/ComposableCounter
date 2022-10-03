//
//  CounterListController.swift
//  ComposableCounter
//
//  Created by Marcel Balas on 07.09.2022.
//

import Combine
import ComposableArchitecture
import Foundation
import UIKit
import SwiftUI

final class CounterListController: StoreCollectionViewController<CounterList.State, CounterList.Action> {

    private enum Section: Int, CaseIterable {
        case counters
    }

    private lazy var dataSource = createDataSource()

    private lazy var cellStores: [UUID: Cancellable] = [:]

    override func createCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        return collectionView
    }

    override func createLayout() -> UICollectionViewCompositionalLayout {
        var configuration = UICollectionLayoutListConfiguration.init(appearance: .insetGrouped)
        configuration.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            guard let self = self, let id = self.dataSource.itemIdentifier(for: indexPath) else { return nil }

            let actionHandler: UIContextualAction.Handler = { action, view, completion in
                self.viewStore.send(.delete(id: id))
                completion(true)
            }

            let action = UIContextualAction(style: .destructive, title: "Delete", handler: actionHandler)
            return UISwipeActionsConfiguration(actions: [action])
        }
        
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CounterList"
        view.addSubview(collectionView)
        dataSource.apply(createSnapshot()([]))

        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
    }

    override func configureStateObservation(on viewStore: ViewStore<CounterList.State, CounterList.Action>) {
        viewStore.publisher.counters
            .removeDuplicates(by: { prev, next in
                // Dont create snapshots if the changes are only _inside_ cells.
                prev.count == next.count && zip(prev.ids, next.ids).allSatisfy(==)
            })
            .map(createSnapshot())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.dataSource.applySnapshot($0, animated: true)
            }
            .store(in: &cancellables)
    }

    private func createDataSource() -> UICollectionViewDiffableDataSource<Section, UUID> {
        let counterRegistration = UICollectionView.CellRegistration<CounterCell, UUID> { cell, indexPath, id in
            // scope to a specific counter given by its `id`
            let cancellable = self.store.scope(
                state: \.counters[id: id],
                action: { .counter(id: id, action: $0) }
            ).ifLet { scopedStore in
                cell.configure(with: scopedStore)
            }
            self.cellStores[id] = cancellable
        }

        return UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, id in
            return collectionView.dequeueConfiguredReusableCell(using: counterRegistration, for: indexPath, item: id)
        }
    }

    private func createSnapshot()
    -> (IdentifiedArrayOf<Counter.State>)
    -> NSDiffableDataSourceSnapshot<Section, UUID> {
        { items in
            var snapshot = NSDiffableDataSourceSnapshot<Section, UUID>()
            snapshot.appendSections([.counters])
            snapshot.appendItems(items.elements.map(\.id), toSection: .counters)
            return snapshot
        }
    }

    @objc func addTapped() {
        viewStore.send(.add)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = dataSource.itemIdentifier(for: indexPath), let counter = viewStore.counters[id: id] {
            let swiftUIController = UIHostingController(
                rootView: CounterDetailView(
                    // We can create a new store and not scoping to an existing one, since we don't bind anything from
                    // the child view to a parent.
                    store: Store(
                        initialState: CounterDetail.State(number: counter.count),
                        reducer: CounterDetail()
                    )
                )
            )
            navigationController?.pushViewController(swiftUIController, animated: true)
        }
    }
}
