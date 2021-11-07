//
//  AppCoordiantor.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 14/04/21.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var countersCoordinator: CountersCoordinator!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let factory = DependencyFactory()
        countersCoordinator = factory.makeCountersCoordinator(navigationController: navigationController)
        countersCoordinator.start()
    }
}
