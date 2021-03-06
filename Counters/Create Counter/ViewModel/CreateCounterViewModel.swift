//
//  CreateItemViewModel.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 28/04/21.
//

import Foundation

final class CreateCounterViewModel {
    private let repository: CountersRepository

    private(set) var viewState: ViewState = .loading {
        didSet {
            didSaveCounter?()
        }
    }

    var didSaveCounter: (() -> Void)?

    // Init
    init(repository: CountersRepository) {
        self.repository = repository
    }

    // MARK: - Fetch Counters
    func save(title: String) {
        viewState = .loading

        repository.save(title: title) {[weak self] result, _ in
            guard let self = self else { return }
            switch result {
            case .success:
                self.viewState = .loaded
            case .failure:
                self.viewState = .error
            }
        }
    }
}

extension CreateCounterViewModel {
    enum ViewState: Equatable {
        case loading
        case loaded
        case error
    }
}
