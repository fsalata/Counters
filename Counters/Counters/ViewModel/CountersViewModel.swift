//
//  CountersViewModel.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 14/05/21.
//

import Foundation

final class CountersViewModel {
    private let repository: CountersRepository

    private(set) var counters: [Counter] = []
    private(set) var filteredCounters: [Counter] = []

    private(set) var viewState: ViewState = .noContent {
        didSet {
            switch viewState {
            case .error(let stateError):
                didChangeState?(viewState, stateError)
            default:
                didChangeState?(viewState, nil)
            }
        }
    }

    // View bindings
    var didChangeState: ((ViewState, ViewStateError?) -> Void)? = { (_, _) in
        fatalError("Not implemented")
    }

    // Init
    init(repository: CountersRepository) {
        self.repository = repository
    }
}

// MARK: - Computed properties
extension CountersViewModel {
    var totalCountersText: String {
        guard counters.count > 0 else {
            return ""
        }

        let totalCounters = counters.count
        let totalTimes = counters.reduce(0) { $0 + $1.count }

        return """
               \(totalCounters) item\(totalCounters > 1 ? "s": "") \
               - Counted \(totalTimes) time\(totalTimes > 1 ? "s": "")
               """
    }

    var isCountersEmpty: Bool {
        return counters.count == 0
    }

    var isFilteredCountersEmpty: Bool {
        return filteredCounters.count == 0
    }
}

// MARK: - Public methods
extension CountersViewModel {
    func checkFirstTimeUse() -> Bool {
        if !repository.checkWelcomeWasShown() {
            repository.setWelcomeWasShown()
            return true
        }

        return false
    }

    func searchCounters(title: String) {
        viewState = .searching
        filteredCounters = counters.filter { $0.title?.lowercased().contains(title.lowercased()) ?? false }
    }

    func didEndFiltering() {
        viewState = .hasContent
        filteredCounters = []
    }

    func shareItems(at indexPaths: [IndexPath]) -> [String] {
        return indexPaths.compactMap { counters[$0.row] }.map { "\($0.count) x \($0.title ?? "")" }
    }
}

// API calls
extension CountersViewModel {
    // MARK: - Fetch counters
    func fetchCounters() {
        viewState = .loading
        
        Task {
            do {
                let (counters, _) = try await repository.fetch()
                self.receiveValueHandler(counters)
            } catch {
                let apiError = APIError(error)
                self.errorHandler(apiError, in: .fetch)
            }
        }
    }
    
    // MARK: - Increment counter
    func incrementCounter(_ counter: Counter) {
        guard let id = counter.id else { return }
        
        Task {
            do {
                let (counters, _) = try await repository.increment(id: id)
                self.receiveValueHandler(counters)
            } catch {
                let apiError = APIError(error)
                self.errorHandler(apiError, in: .fetch)
            }
        }
    }
    
    // MARK: - Decrement counter
    func decrementCounter(_ counter: Counter) {
        guard let id = counter.id,
              counter.count > 0 else { return }
        
        Task {
            do {
                let (counters, _) = try await repository.decrement(id: id)
                self.receiveValueHandler(counters)
            } catch {
                let apiError = APIError(error)
                self.errorHandler(apiError, in: .fetch)
            }
        }
    }
    
    // MARK: - Delete counter(s)
    func deleteCounters(at indexPaths: [IndexPath]) async {
        viewState = .loading
        
        let selectedCountersIds = indexPaths.compactMap {  indexPath in
            return counters[indexPath.row].id
        }
        
        var remainingCounters: [Counter] = []
        var failedToDelete: (error: APIError, counter: Counter)?
        
        for id in selectedCountersIds {
            
            do {
                (remainingCounters, _) = try await repository.delete(id: id)
            } catch {
                if let counter = self.counters.first(where: { $0.id == id }) {
                    failedToDelete = (error: APIError(error), counter: counter)
                }
            }
        }
        
        if let failedToDelete = failedToDelete {
            let (error, counter) = failedToDelete
            self.errorHandler(error, in: .delete(counter))
        } else {
            self.receiveValueHandler(remainingCounters)
        }
    }
}

// MARK: - Private methods
private extension CountersViewModel {
    // Received value handler
    func receiveValueHandler(_ counters: [Counter]) {
        self.counters = counters
        updateFilteredCounters()
        viewState = counters.isEmpty ? .noContent : .hasContent
        repository.setCacheFor(counters: counters)
    }

    func updateFilteredCounters() {
        guard filteredCounters.count > 0 else { return }

        filteredCounters = filteredCounters.map { filteredCounter in
            return counters.first { $0.id == filteredCounter.id } ?? filteredCounter
        }
    }

    // MARK: - Received completion handler
    func errorHandler(_ error: APIError, in type: ViewErrorType) {
        if type == .fetch,
           case .network = error,
           let cachedCounters = self.repository.getCachedCounters() {
            self.receiveValueHandler(cachedCounters)
            return
        }

        var title: String?
        var message: String? = "The Internet connection appears to be offline."

        switch type {
        case .fetch:
            title = "Couldn’t update counters"
            counters = []

        case .increment(let counter):
            title = "Couldn’t update the \"\(counter.title ?? "")\" counter to \(counter.count + 1)"

        case .decrement(let counter):
            title = "Couldn’t update the \"\(counter.title ?? "")\" counter to \(counter.count - 1)"

        case .delete(let counter):
            title = "Couldn’t delete the counter \"\(counter.title ?? "")\""

        case .none:
            title = nil
            message = nil
        }

        let viewStateError = ViewStateError(title: title, message: message, type: type)
        viewState = .error(viewStateError)
    }
}

// MARK: View State
extension CountersViewModel {
    enum ViewState: Equatable {
        case noContent
        case loading
        case hasContent
        case searching
        case error(ViewStateError)
    }

    struct ViewStateError: Equatable {
        let title: String?
        let message: String?
        let type: ViewErrorType
    }

    enum ViewErrorType: Equatable {
        case fetch
        case increment(_ counter: Counter)
        case decrement(_ counter: Counter)
        case delete(_ counter: Counter)
        case none
    }
    
    enum Sections {
        case main
    }
}
