//
//  ExamplesCoordinator.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 21/06/21.
//

import UIKit

class ExamplesCoordinator: Coordinator {
    let navigationController: UINavigationController
    let factory: ExamplesFactory

    var viewModel: ExamplesViewModel

    init(navigationController: UINavigationController, viewModel: ExamplesViewModel, factory: ExamplesFactory) {
        self.navigationController = navigationController
        self.viewModel = viewModel
        self.factory = factory
    }

    func start() {
        let examplesViewControler = factory.makeExamplesViewController(coordinator: self, viewModel: viewModel)
        navigationController.pushViewController(examplesViewControler, animated: true)
    }
}
