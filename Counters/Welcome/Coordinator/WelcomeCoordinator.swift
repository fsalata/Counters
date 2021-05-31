//
//  WelcomeCoordinator.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 24/04/21.
//

import UIKit

final class WelcomeCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = WelcomeViewModel()
        let welcomeViewController = WelcomeViewController(coordinator: self, viewModel: viewModel)
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(welcomeViewController, animated: true)
    }
}

extension WelcomeCoordinator {
    func dismiss() {
        navigationController.navigationBar.isHidden = false
        navigationController.dismiss(animated: true, completion: nil)
    }
}
