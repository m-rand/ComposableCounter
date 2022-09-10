//
//  CounterCell.swift
//  ComposableCounter
//
//  Created by Marcel Balas on 07.09.2022.
//

import ComposableArchitecture
import UIKit

final class CounterCell: StoreCell<CounterState, CounterAction> {

//    var counter: CounterState? // not needed here!

    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = .monospacedDigitSystemFont(ofSize: 17, weight: .regular)
        return label
    }()

    override func setupViews() {
        super.setupViews()

        backgroundColor = .systemBackground

        let decrementButton = UIButton(type: .system)
        decrementButton.addTarget(self, action: #selector(decrementButtonTapped), for: .touchUpInside)
        decrementButton.setTitle("−", for: .normal)

        let incrementButton = UIButton(type: .system)
        incrementButton.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)
        incrementButton.setTitle("+", for: .normal)

        let rootStackView = UIStackView(arrangedSubviews: [
            decrementButton,
            countLabel,
            incrementButton,
        ])
        rootStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        contentView.addSubview(rootStackView)

        NSLayoutConstraint.activate([
            rootStackView.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
            rootStackView.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
        ])
    }

    override func configureStateObservation(on viewStore: ViewStore<CounterState, CounterAction>) {
        viewStore
            .publisher
            .map { "\($0.count)" }
            .assign(to: \.text, on: countLabel)
            .store(in: &self.cancellables)
    }

    @objc func decrementButtonTapped() {
        viewStore?.send(.decrementButtonTapped)
    }

    @objc func incrementButtonTapped() {
        viewStore?.send(.incrementButtonTapped)
    }
}
