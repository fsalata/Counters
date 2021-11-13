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
    let navigationController: UINavigationController
    private let factory: WelcomeFactory

    weak var delegate: WelcomeCoordinatorDelegate?

    init(navigationController: UINavigationController, factory: WelcomeFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }

    func start() {
        let welcomeViewController = factory.makeWelcomeViewController(coordinator: self)
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
