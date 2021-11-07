//
//  Factory.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 07/11/21.
//

import UIKit

// Counters
protocol CountersFactory {
    func makeCountersCoordinator(navigationController: UINavigationController) -> CountersCoordinator
    func makeCountersViewModel() -> CountersViewModel
    func makeCountersViewController(coordinator: CountersCoordinator) -> CountersViewController
}

// Welcome
protocol WelcomeFactory {
    func makeWelcomeCoordinator(navigationController: UINavigationController) -> WelcomeCoordinator
    func makeWelcomeViewModel() -> WelcomeViewModel
    func makeWelcomeViewController(coordinator: WelcomeCoordinator) -> WelcomeViewController
}

// Create
protocol CreateCounterFactory {
    func makeCreateCountersCoordinator(navigationController: UINavigationController) -> CreateCounterCoordinator
    func makeCreateCounterViewModel() -> CreateCounterViewModel
    func makeCreateCounterViewController(coordinator: CreateCounterCoordinator) -> CreateCounterViewController
}

// Examples
protocol ExamplesFactory {
    func makeExamplesCoordinator(navigationController: UINavigationController, viewModel: ExamplesViewModel) -> ExamplesCoordinator
    func makeExamplesViewModel() -> ExamplesViewModel
    func makeExamplesViewController(coordinator: ExamplesCoordinator, viewModel: ExamplesViewModel) -> ExamplesViewController
}
