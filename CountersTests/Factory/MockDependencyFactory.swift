//
//  DependencyFactory.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 07/11/21.
//

import Foundation
import UIKit
@testable import Counters

final class MockDependencyFactory {
    lazy var navigationController = UINavigationController()
    lazy var api = CountersApi()
    lazy var session = URLSessionSpy()
    lazy var client = APIClient(session: session, api: MockAPI())
    lazy var service = CountersService(client: client)
    lazy var userDefaults = UserDefaults.standard
}

// MARK: Counters
extension MockDependencyFactory: CountersFactory {
    func makeCountersCoordinator() -> CountersCoordinator {
        return CountersCoordinator(navigationController: navigationController, factory: self)
    }

    func makeCountersViewModel() -> CountersViewModel {
        return CountersViewModel(service: service, userDefaults: userDefaults)
    }

    func makeCountersViewController(coordinator: CountersCoordinator) -> CountersViewController {
        return CountersViewController(coordinator: coordinator, viewModel: makeCountersViewModel())
    }
}

// MARK: Welcome
extension MockDependencyFactory: WelcomeFactory {
    func makeWelcomeCoordinator() -> WelcomeCoordinator {
        return WelcomeCoordinator(navigationController: navigationController, factory: self)
    }

    func makeWelcomeViewModel() -> WelcomeViewModel {
        let features = WelcomeFeature.getFeatures()
        return WelcomeViewModel(features: features)
    }

    func makeWelcomeViewController(coordinator: WelcomeCoordinator) -> WelcomeViewController {
        WelcomeViewController(coordinator: coordinator, viewModel: makeWelcomeViewModel())
    }
}

// MARK: Create Counter
extension MockDependencyFactory: CreateCounterFactory {
    func makeCreateCountersCoordinator() -> CreateCounterCoordinator {
        return CreateCounterCoordinator(navigationController: navigationController, factory: self)
    }

    func makeCreateCounterViewModel() -> CreateCounterViewModel {
        return CreateCounterViewModel(service: service)
    }

    func makeCreateCounterViewController(coordinator: CreateCounterCoordinator) -> CreateCounterViewController {
        return CreateCounterViewController(coordinator: coordinator, viewModel: makeCreateCounterViewModel())
    }
}

// MARK: Examples
extension MockDependencyFactory: ExamplesFactory {
    func makeExamplesCoordinator(viewModel: ExamplesViewModel) -> ExamplesCoordinator {
        return ExamplesCoordinator(navigationController: navigationController,
                                   viewModel: viewModel,
                                   factory: self)
    }

    func makeExamplesViewModel() -> ExamplesViewModel {
        return ExamplesViewModel()
    }

    func makeExamplesViewController(coordinator: ExamplesCoordinator, viewModel: ExamplesViewModel) -> ExamplesViewController {
        return ExamplesViewController(coordinator: coordinator, viewModel: viewModel)
    }
}
