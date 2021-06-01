//
//  CountersCoordinator.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 14/05/21.
//

import UIKit

final class CountersCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = CountersViewModel()
        let countersViewController = CountersViewController(coordinator: self, viewModel: viewModel)
        navigationController.pushViewController(countersViewController, animated: true)
    }
}

extension CountersCoordinator {
    func presentWelcomeScreen() {
        let welcomeCoordinator = WelcomeCoordinator(navigationController: navigationController)
        welcomeCoordinator.start()
    }

    func presentCreateItem() {
        let createItemCoordinator = CreateCounterCoordinator(navigationController: navigationController)
        createItemCoordinator.start()
    }
}
