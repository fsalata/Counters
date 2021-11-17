//
//  UIResponder+Error.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 16/11/21.
//

import UIKit

extension UIResponder {
    class ErrorMessage: NSObject {
        let title: String?
        let message: String?
        let actionButtons: [UIAlertAction]?
        let style: UIAlertController.Style

        init(title: String?,
             message: String?,
             actionButtons: [UIAlertAction]?,
             style: UIAlertController.Style = .alert) {
            self.title = title
            self.message = message
            self.actionButtons = actionButtons
            self.style = style
        }
    }
}

extension UIResponder {
    @objc func handle(error: ErrorMessage, from viewController: UIViewController) {
        guard let nextResponder = next else {
            return assertionFailure("Unhandled error \(error) from \(viewController)")
        }

        nextResponder.handle(error: error, from: viewController)
    }
}
