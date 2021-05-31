//
//  UITableView+Extensions.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 14/05/21.
//

import UIKit

extension UITableView {

    /// Register cell from nib
    /// - Parameter type: UITableViewCell type
    func registerCell<T: UITableViewCell>(of type: T.Type) {
        let nib = UINib(nibName: String(describing: type.self), bundle: nil)
        register(nib, forCellReuseIdentifier: String(describing: T.self))
    }

    /// Dequeue cell and configure
    /// - Parameters:
    ///   - type: UITableViewCell type
    ///   - indexPath: cell indexPath
    ///   - configure: closure to handle cell configuration
    /// - Returns: returns configured cell
    func dequeueCell<T: UITableViewCell>(of type: T.Type,
                                         for indexPath: IndexPath,
                                         configure: @escaping ((T) -> Void) = { _ in }) -> UITableViewCell {

        let cell = self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath)

        if let cell = cell as? T {
            configure(cell)
        }

        return cell
    }
}
