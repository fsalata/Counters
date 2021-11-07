//
//  DependencyFactory.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 07/11/21.
//

import Foundation
import UIKit

final class DependencyFactory {
    lazy var api = CountersApi()
    lazy var session = URLSession.shared
    lazy var apiClient = APIClient(session: session, api: api)
    lazy var userDefaults = UserDefaults.standard

    func makeCountersService() -> CountersService {
        return CountersService(client: apiClient)
    }
}

// MARK: Counters
extension DependencyFactory: CountersFactory {
    func makeCountersCoordinator(navigationController: UINavigationController) -> CountersCoordinator {
        return CountersCoordinator(navigationController: navigationController, factory: self)
    }

    func makeCountersViewModel() -> CountersViewModel {
        return CountersViewModel(service: makeCountersService(), userDefaults: userDefaults)
    }

    func makeCountersViewController(coordinator: CountersCoordinator) -> CountersViewController {
        return CountersViewController(coordinator: coordinator, viewModel: makeCountersViewModel())
    }
}

// MARK: Welcome
extension DependencyFactory: WelcomeFactory {
    func makeWelcomeCoordinator(navigationController: UINavigationController) -> WelcomeCoordinator {
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
extension DependencyFactory: CreateCounterFactory {
    func makeCreateCountersCoordinator(navigationController: UINavigationController) -> CreateCounterCoordinator {
        return CreateCounterCoordinator(navigationController: navigationController, factory: self)
    }

    func makeCreateCounterViewModel() -> CreateCounterViewModel {
        return CreateCounterViewModel(service: makeCountersService())
    }

    func makeCreateCounterViewController(coordinator: CreateCounterCoordinator) -> CreateCounterViewController {
        return CreateCounterViewController(coordinator: coordinator, viewModel: makeCreateCounterViewModel())
    }
}

// MARK: Examples
extension DependencyFactory: ExamplesFactory {
    func makeExamplesCoordinator(navigationController: UINavigationController, viewModel: ExamplesViewModel) -> ExamplesCoordinator {
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
