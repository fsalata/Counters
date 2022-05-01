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
    private lazy var userDefaults = UserDefaultsMock()
    private lazy var cache = CacheActor.shared
    private lazy var repository = CountersRepository(client: client,
                                                     userDefaults: userDefaults,
                                                     cache: cache)

    func makeCountersRepository() -> CountersRepository {
        CountersRepository(client: client,
                           userDefaults: userDefaults,
                           cache: cache)
    }
}

// MARK: Counters
extension MockDependencyFactory: CountersFactory {
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
        return CreateCounterViewModel(repository: repository)
    }

    func makeCreateCounterViewController(coordinator: CreateCounterCoordinator) -> CreateCounterViewController {
        return CreateCounterViewController(coordinator: coordinator, viewModel: makeCreateCounterViewModel())
    }
}

// MARK: Examples
extension MockDependencyFactory: ExamplesFactory {
    func makeExamplesCoordinator(navigationController: UINavigationController,
                                 viewModel: ExamplesViewModel) -> ExamplesCoordinator {
        return ExamplesCoordinator(navigationController: navigationController,
                                   viewModel: viewModel,
                                   factory: self)
    }

    func makeExamplesViewModel() -> ExamplesViewModel {
        return ExamplesViewModel()
    }

    func makeExamplesViewController(coordinator: ExamplesCoordinator,
                                    viewModel: ExamplesViewModel) -> ExamplesViewController {
        return ExamplesViewController(coordinator: coordinator, viewModel: viewModel)
    }
}
