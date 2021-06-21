//
//  ExamplesCoordinator.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 21/06/21.
//

import UIKit

class ExamplesCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = ExamplesViewModel()
        let examplesViewControler = ExamplesViewController(coordinator: self, viewModel: viewModel)
        navigationController.pushViewController(examplesViewControler, animated: true)
    }
}
