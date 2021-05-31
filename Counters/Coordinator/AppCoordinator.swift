//
//  AppCoordiantor.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 14/04/21.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let welcomeCoordinator = WelcomeCoordinator(navigationController: navigationController)
        welcomeCoordinator.start()
    }
}
