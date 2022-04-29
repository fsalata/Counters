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

        Task {
            do {
                try await repository.save(title: title)
                self.viewState = .loaded
            } catch {
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
