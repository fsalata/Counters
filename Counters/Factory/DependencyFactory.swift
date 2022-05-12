//
//  DependencyFactory.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 07/11/21.
//

import UIKit
import NetworkLayer

final class DependencyFactory {
    lazy var navigationController = UINavigationController()
    private lazy var api = CountersApi()
    private lazy var session = URLSession.shared
    private lazy var client = APIClient(session: session, api: api)
    private lazy var userDefaults = UserDefaults.standard
    private lazy var cache = Cache.shared
    private lazy var repository = CountersRepository(client: client,
                                                     userDefaults: userDefaults,
                                                     cache: cache)
}

// MARK: App Coordinator
extension DependencyFactory: AppCoordinatorFactory {
    func makeAppCoordinator() -> AppCoordinator {
        return AppCoordinator(navigationController: navigationController, factory: self)
    }
}

// MARK: Counters
extension DependencyFactory: CountersFactory {
    func makeCountersCoordinator() -> CountersCoordinator {
        return CountersCoordinator(navigationController: navigationController, factory: self)
    }

    func makeCountersViewModel() -> CountersViewModel {
        return CountersViewModel(repository: repository)
    }

    func makeCountersViewController(coordinator: CountersCoordinator) -> CountersViewController {
        return CountersViewController(coordinator: coordinator, viewModel: makeCountersViewModel())
    }
}

// MARK: Welcome
extension DependencyFactory: WelcomeFactory {
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
extension DependencyFactory: CreateCounterFactory {
    func makeCreateCountersCoordinator() -> CreateCounterCoordinator {
        return CreateCounterCoordinator(navigationController: navigationController, factory: self)
    }

    func makeCreateCounterViewModel() -> CreateCounterViewModel {
        return CreateCounterViewModel(repository: repository)
    }

    func makeCreateCounterViewController(coordinator: CreateCounterCoordinator) -> CreateCounterViewController {
        return CreateCounterViewController(coordinator: coordinator, viewModel: makeCreateCounterViewModel())
    }
}

// MARK: Examples
extension DependencyFactory: ExamplesFactory {
    func makeExamplesCoordinator(navigationController: UINavigationController,
                                 viewModel: ExamplesViewModel) -> ExamplesCoordinator {
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
