//
//  ExamplesCoordinator.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 21/06/21.
//

import UIKit

class ExamplesCoordinator: Coordinator {
    var navigationController: UINavigationController

    var viewModel: ExamplesViewModel

    init(navigationController: UINavigationController, viewModel: ExamplesViewModel = ExamplesViewModel()) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }

    func start() {
        let examplesViewControler = ExamplesViewController(coordinator: self, viewModel: viewModel)
        navigationController.pushViewController(examplesViewControler, animated: true)
    }
}
