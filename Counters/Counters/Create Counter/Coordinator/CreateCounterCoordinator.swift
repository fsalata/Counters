//
//  CreateItemCoordinator.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 28/04/21.
//

import UIKit

final class CreateCounterCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = CreateCounterViewModel()
        let createItemViewController = CreateCounterViewController(coordinator: self, viewModel: viewModel)

        let innerNavigationController = UINavigationController(rootViewController: createItemViewController)
        innerNavigationController.modalPresentationStyle = .fullScreen

        navigationController.present(innerNavigationController, animated: true)
    }
}
