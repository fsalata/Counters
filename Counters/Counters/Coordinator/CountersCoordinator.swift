//
//  CountersCoordinator.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 14/05/21.
//

import UIKit

final class CountersCoordinator: Coordinator {
    var navigationController: UINavigationController

    var createCounterCoordinator: CreateCounterCoordinator!
    var welcomeCoordinator: WelcomeCoordinator!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = CountersViewModel()
        let countersViewController = CountersViewController(coordinator: self, viewModel: viewModel)
        navigationController.pushViewController(countersViewController, animated: true)
    }

    // MARK: - View controller methods
    func presentWelcomeScreen() {
        welcomeCoordinator = WelcomeCoordinator(navigationController: navigationController)
        welcomeCoordinator.start()
        welcomeCoordinator.delegate = self
    }

    func presentCreateItem() {
        createCounterCoordinator = CreateCounterCoordinator(navigationController: navigationController)
        createCounterCoordinator.start()
        createCounterCoordinator.delegate = self
    }
}

// MARK: - WelcomeCoordinatorDelegate
extension CountersCoordinator: WelcomeCoordinatorDelegate {
    func welcomeCoordinatorDidFinish(_ coordinator: WelcomeCoordinator) {
        welcomeCoordinator = nil
    }
}

// MARK: - CreateCounterCoordinatorDelegate
extension CountersCoordinator: CreateCounterCoordinatorDelegate {
    func createCounterCoordinatorDidFinish(_ coordinator: CreateCounterCoordinator) {
        createCounterCoordinator = nil
    }
}
