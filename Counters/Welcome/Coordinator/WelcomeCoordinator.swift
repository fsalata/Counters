//
//  WelcomeCoordinator.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 24/04/21.
//

import UIKit

protocol WelcomeCoordinatorDelegate: AnyObject {
    func welcomeCoordinatorDidFinish(_ coordinator: WelcomeCoordinator)
}

class WelcomeCoordinator: Coordinator {
    var navigationController: UINavigationController

    weak var delegate: WelcomeCoordinatorDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = WelcomeViewModel()
        let welcomeViewController = WelcomeViewController(coordinator: self, viewModel: viewModel)
        welcomeViewController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.isHidden = true
        navigationController.present(welcomeViewController, animated: true)
    }

    // MARK: - View controller methods
    func dismiss() {
        DispatchQueue.main.async {
            self.navigationController.navigationBar.isHidden = false
            self.navigationController.dismiss(animated: true, completion: nil)
            self.delegate?.welcomeCoordinatorDidFinish(self)
        }
    }
}
