//
//  CreateItemViewModel.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 28/04/21.
//

import Foundation
import Combine

final class CreateCounterViewModel {
    let storageProvider: StorageProvider

    private(set) var viewState: ViewState = .loading {
        didSet {
            didSaveCounter?()
        }
    }

    var didSaveCounter: (() -> Void)?

    // Init
    init(storageProvider: StorageProvider = StorageProvider()) {
        self.storageProvider = storageProvider
    }

    // MARK: - Fetch Counters
    func save(title: String) {
        viewState = .loading
        storageProvider.saveCounter(named: title)
        viewState = .loaded
    }
}

extension CreateCounterViewModel {
    enum ViewState: Equatable {
        case loading
        case loaded
        case error
    }
}
