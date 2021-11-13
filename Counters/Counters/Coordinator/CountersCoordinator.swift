//
//  CountersCoordinator.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 14/05/21.
//

import UIKit

class CountersCoordinator: Coordinator {
    let navigationController: UINavigationController

    typealias Factory = CountersFactory & WelcomeFactory & CreateCounterFactory
    private let factory: Factory

    private var createCounterCoordinator: CreateCounterCoordinator!
    private var welcomeCoordinator: WelcomeCoordinator!

    init(navigationController: UINavigationController, factory: Factory) {
        self.navigationController = navigationController
        self.factory = factory
    }

    func start() {
        let countersViewController = factory.makeCountersViewController(coordinator: self)
        navigationController.pushViewController(countersViewController, animated: true)
    }

    // MARK: - View controller methods
    func presentWelcomeScreen() {
        welcomeCoordinator = factory.makeWelcomeCoordinator()
        welcomeCoordinator.start()
        welcomeCoordinator.delegate = self
    }

    func presentCreateItem() {
        createCounterCoordinator = factory.makeCreateCountersCoordinator()
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
