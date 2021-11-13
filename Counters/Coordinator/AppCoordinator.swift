//
//  AppCoordiantor.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 14/04/21.
//

import UIKit

class AppCoordinator: Coordinator {
    let navigationController: UINavigationController
    let factory: CountersFactory

    var countersCoordinator: CountersCoordinator!

    init(navigationController: UINavigationController, factory: CountersFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }

    func start() {
        countersCoordinator = factory.makeCountersCoordinator()
        countersCoordinator.start()
    }
}
