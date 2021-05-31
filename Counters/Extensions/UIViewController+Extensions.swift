//
//  UIViewController+Extensions.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 14/05/21.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?,
                   message: String?,
                   actionButtons: [UIAlertAction]?,
                   style: UIAlertController.Style = .alert ) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: style)

        actionButtons?.forEach { button in
            alertController.addAction(button)
        }

        if let preferredAction = actionButtons?.first {
            alertController.preferredAction = preferredAction
        }

        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(dismissAction)

        alertController.view.tintColor = .orange

        self.present(alertController, animated: true)
    }
}
