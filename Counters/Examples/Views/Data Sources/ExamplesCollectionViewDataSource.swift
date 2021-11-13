//
//  ExamplesCollectionViewDataSource.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 12/07/21.
//

import UIKit

final class ExamplesCollectionViewDataSource: NSObject {
    private let examples: [String: [Example]]
    private let sectionKeys: [String]

    init(_ examples: [String: [Example]]) {
        self.examples = examples
        self.sectionKeys = Array(examples.keys).sorted(by: <)
    }
}

extension ExamplesCollectionViewDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return examples.keys.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return examples[sectionKeys[section]]?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueCell(of: ExampleCollectionViewCell.self, for: indexPath) {[weak self] cell in
            guard let self = self else { return }

            let sectionKey = self.sectionKeys[indexPath.section]

            if let sectionItems = self.examples[sectionKey] {
                let item = sectionItems[indexPath.row]
                cell.configure(example: item)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let identifier = String(describing: ExampleHeaderCollectionReusableView.self)
        if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                        withReuseIdentifier: identifier,
                                                                        for: indexPath) as? ExampleHeaderCollectionReusableView {
            header.configure(title: sectionKeys[indexPath.section])
            return header
        }

        return UICollectionReusableView()
    }
}
