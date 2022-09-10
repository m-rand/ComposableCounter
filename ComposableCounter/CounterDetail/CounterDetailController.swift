//
//  CounterDetailController.swift
//  ComposableCounter
//
//  Created by Marcel Balas on 08.09.2022.
//

import ComposableArchitecture
import UIKit

final class CounterDetailController: StoreViewController<CounterDetailState, CounterDetailAction> {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewStore.send(.onAppear(self.viewStore.number))
    }

    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()

    private lazy var factLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()

    private func setupViews() {
        view.backgroundColor = .systemBackground

        let rootStackView = UIStackView(arrangedSubviews: [
            countLabel,
            factLabel
        ])
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.addSubview(rootStackView)

        NSLayoutConstraint.activate([
            rootStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            rootStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }

    override func configureStateObservation(on viewStore: ViewStore<CounterDetailState, CounterDetailAction>) {
        viewStore.publisher.number
            .map(String.init)
            .assign(to: \.text, on: countLabel)
            .store(in: &cancellables)

        viewStore.publisher.fact
            .assign(to: \.text, on: factLabel)
            .store(in: &cancellables)
    }
}
