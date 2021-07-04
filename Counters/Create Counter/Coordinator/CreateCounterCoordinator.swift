//
//  CreateItemCoordinator.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 28/04/21.
//

import UIKit

final class CreateCounterCoordinator: Coordinator {
    let navigationController: UINavigationController
    var innerNavigationController: UINavigationController!

    var createCounterViewController: CreateCounterViewController!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = CreateCounterViewModel()
        createCounterViewController = CreateCounterViewController(coordinator: self, viewModel: viewModel)

        innerNavigationController = UINavigationController(rootViewController: createCounterViewController)
        innerNavigationController.modalPresentationStyle = .fullScreen

        navigationController.present(innerNavigationController, animated: true)
    }

    func stop() {
        self.innerNavigationController = nil
        self.createCounterViewController = nil
    }

    // MARK: View controller methods
    func presentExamplesScreen() {
        let examplesViewModel = ExamplesViewModel()
        examplesViewModel.delegate = createCounterViewController

        let examplesCoordinator = ExamplesCoordinator(navigationController: innerNavigationController,
                                                      viewModel: examplesViewModel)
        examplesCoordinator.start()
    }
}
