//
//  CreateItemCoordinator.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 28/04/21.
//

import UIKit

protocol CreateCounterCoordinatorDelegate: AnyObject {
    func createCounterCoordinatorDidFinish(_ coordinator: CreateCounterCoordinator)
}

class CreateCounterCoordinator: Coordinator {
    let navigationController: UINavigationController
    private(set) var innerNavigationController: UINavigationController!

    var examplesCoordinator: ExamplesCoordinator!
    var createCounterViewController: CreateCounterViewController!

    weak var delegate: CreateCounterCoordinatorDelegate?

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

    // MARK: View controller methods
    func presentExamplesScreen() {
        let examplesViewModel = ExamplesViewModel()
        examplesViewModel.delegate = createCounterViewController

        examplesCoordinator = ExamplesCoordinator(navigationController: innerNavigationController,
                                                      viewModel: examplesViewModel)
        examplesCoordinator.start()
    }

    func dismiss() {
        DispatchQueue.main.async {
            self.navigationController.dismiss(animated: true)
            self.stop()
            self.delegate?.createCounterCoordinatorDidFinish(self)
        }
    }
}

private extension CreateCounterCoordinator {
    func stop() {
        innerNavigationController = nil
        createCounterViewController = nil
        examplesCoordinator = nil
    }
}
