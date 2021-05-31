//
//  UIStackView+Extensions.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 25/04/21.
//

import UIKit

extension UIStackView {
    /// Add multiple arranjed subviews
    /// - Parameter subviews: subviews to be added.
    func addArrangedSubviews(_ subviews: UIView...) {
        subviews.forEach(addArrangedSubview)
    }
}
