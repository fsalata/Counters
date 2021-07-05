//
//  CountersViewModel.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 14/05/21.
//

import Foundation

final class CountersViewModel: ObservableObject {
    private let service: CountersService

    private(set) var counters: [Counter] = []

    private(set) var viewState: ViewState = .noContent {
        didSet {
            switch viewState {
            case .error(let stateError):
                didChangeState?(viewState, totalCountersText, stateError)
            default:
                didChangeState?(viewState, totalCountersText, nil)
            }
        }
    }

    private var totalCountersText: String {
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

    private(set) var filteredCounters: [Counter] = []

    private let firstTimeOpenKey = "FirstOpen"

    private var cache = Cache.shared
    private var countersCacheKey = "counters"

    // View bindings
    var didChangeState: ((ViewState, String, ViewStateError?) -> Void)?

    var isCountersEmpty: Bool {
        return counters.count == 0
    }

    var isFilteredCountersEmpty: Bool {
        return filteredCounters.count == 0
    }

    // Init
    init(service: CountersService = CountersService()) {
        self.service = service
    }
}

// MARK: - Public methods
extension CountersViewModel {
    func checkFirstTimeUse() -> Bool {
        if UserDefaults.standard.object(forKey: firstTimeOpenKey) == nil {
            UserDefaults.standard.setValue(false, forKey: firstTimeOpenKey)
            return true
        }

        return false
    }

    func filterCounters(title: String) {
        viewState = .searching
        filteredCounters = counters.filter { $0.title?.lowercased().contains(title.lowercased()) ?? false }
    }

    func didEndFiltering() {
        viewState = .hasContent
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
        service.fetch {[weak self] result, _ in
            guard let self = self else { return }

            switch result {
            case .success(let counters):
                self.receiveValueHandler(counters)
            case .failure(let error):
                self.errorHandler(error, in: .fetch)
            }
        }
    }

    // MARK: - Increment counter
    func incrementCounter(_ counter: Counter) {
        guard let id = counter.id else { return }

        service.increment(id: id) {[weak self] result, _ in
            guard let self = self else { return }

            switch result {
            case .success(let counters):
                self.receiveValueHandler(counters)
            case .failure(let error):
                self.errorHandler(error, in: .increment(counter))
            }
        }
    }

    // MARK: - Decrement counter
    func decrementCounter(_ counter: Counter) {
        guard let id = counter.id,
              counter.count > 0 else { return }

        service.decrement(id: id) {[weak self] result, _ in
            guard let self = self else { return }

            switch result {
            case .success(let counters):
                self.receiveValueHandler(counters)
            case .failure(let error):
                self.errorHandler(error, in: .decrement(counter))
            }
        }
    }

    // MARK: - Delete counter(s)
    func deleteCounters(at indexPaths: [IndexPath], completion: @escaping () -> Void) {
        viewState = .loading

        let selectedCountersIds = indexPaths.compactMap {  indexPath in
            return counters[indexPath.row].id
        }

        let dispatchGroup = DispatchGroup()

        var remainingCounters: [Counter] = []
        var failedToDelete: (error: APIError, counter: Counter)?

        for id in selectedCountersIds {
            dispatchGroup.enter()

            service.delete(id: id) { result, _ in
                switch result {
                case .success(let counters):
                    remainingCounters = counters
                case .failure(let error):
                    if let counter = self.counters.first(where: { $0.id == id }) {
                        failedToDelete = (error: error, counter: counter)
                    }
                }

                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            if let failedToDelete = failedToDelete {
                let (error, counter) = failedToDelete
                self.errorHandler(error, in: .delete(counter))
            } else {
                self.receiveValueHandler(remainingCounters)
            }

            completion()
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
        cache.set(key: countersCacheKey, object: counters)
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
           case .network(_) = error,
           let cachedCounters = self.cache.get(key: self.countersCacheKey) {
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
}
