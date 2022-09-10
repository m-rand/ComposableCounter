//
//  Helpers.swift
//  ComposablePodcastTestApp
//
//  Created by Marcel Balas on 07.06.2022.
//

import Combine
import IdentifiedCollections
import OrderedCollections
import UIKit

// MARK: - UICollectionViewDiffableDataSource

extension UICollectionViewDiffableDataSource {
    func reloadData(
        snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
        completion: (() -> Void)? = nil
    ) {
        if #available(iOS 15.0, *) {
            self.applySnapshotUsingReloadData(snapshot, completion: completion)
        } else {
            self.apply(snapshot, animatingDifferences: false, completion: completion)
        }
    }

    func applySnapshot(
        _ snapshot: NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>,
        animated: Bool,
        completion: (() -> Void)? = nil) {

            if #available(iOS 15.0, *) {
                self.apply(snapshot, animatingDifferences: animated, completion: completion)
            } else {
                if animated {
                    self.apply(snapshot, animatingDifferences: true, completion: completion)
                } else {
                    UIView.performWithoutAnimation {
                        self.apply(snapshot, animatingDifferences: true, completion: completion)
                    }
                }
            }
        }
}
