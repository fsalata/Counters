//
//  UICollectionView+Extensions.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 21/06/21.
//

import UIKit

extension UICollectionView {

    /// Register cell from nib
    /// - Parameter type: UITableViewCell type
    func registerCell<T: UICollectionViewCell>(of type: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
    }

    /// Dequeue cell and configure
    /// - Parameters:
    ///   - type: UITableViewCell type
    ///   - indexPath: cell indexPath
    ///   - configure: closure to handle cell configuration
    /// - Returns: returns configured cell
    func dequeueCell<T: UICollectionViewCell>(of type: T.Type,
                                              for indexPath: IndexPath,
                                              configure: @escaping ((T) -> Void) = { _ in }) -> UICollectionViewCell {

        let cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath)

        if let cell = cell as? T {
            configure(cell)
        }

        return cell
    }
}
