//
//  Factories.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 07/11/21.
//

import UIKit

// App Coordinator
protocol AppCoordinatorFactory {
    func makeAppCoordinator() -> AppCoordinator
}

// Counters
protocol CountersFactory {
    func makeCountersCoordinator() -> CountersCoordinator
    func makeCountersViewModel() -> CountersViewModel
    func makeCountersViewController(coordinator: CountersCoordinator) -> CountersViewController
}

// Welcome
protocol WelcomeFactory {
    func makeWelcomeCoordinator() -> WelcomeCoordinator
    func makeWelcomeViewModel() -> WelcomeViewModel
    func makeWelcomeViewController(coordinator: WelcomeCoordinator) -> WelcomeViewController
}

// Create
protocol CreateCounterFactory {
    func makeCreateCountersCoordinator() -> CreateCounterCoordinator
    func makeCreateCounterViewModel() -> CreateCounterViewModel
    func makeCreateCounterViewController(coordinator: CreateCounterCoordinator) -> CreateCounterViewController
}

// Examples
protocol ExamplesFactory {
    func makeExamplesCoordinator(viewModel: ExamplesViewModel) -> ExamplesCoordinator
    func makeExamplesViewModel() -> ExamplesViewModel
    func makeExamplesViewController(coordinator: ExamplesCoordinator, viewModel: ExamplesViewModel) -> ExamplesViewController
}
