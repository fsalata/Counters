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
    private(set) var error: TargetError?

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

    private var isFirstTimeUse: Bool = true

    var didUpdateCounters: ((String) -> Void)?
    var didError: ((ErrorType) -> Void)?

    var isCountersEmpty: Bool {
        return counters.count == 0
    }

    var isFilteredCountersEmpty: Bool {
        return filteredCounters.count == 0
    }

    typealias TargetError = (error: APIError?, title: String?, message: String?, type: ErrorType)

    // Init
    init(service: CountersService = CountersService()) {
        self.service = service
    }
}

// MARK: - Public methods
extension CountersViewModel {
    // TODO: check first time use and save in user defaults
    func checkFirstTimeUse() -> Bool {
        if isFirstTimeUse {
            isFirstTimeUse = false
            return true
        }

        return false
    }

    func filterCounters(title: String, refresh: () -> Void) {
        filteredCounters = counters.filter { $0.title?.lowercased().contains(title.lowercased()) ?? false }
        refresh()
    }

    func shareItems(at indexPaths: [IndexPath]) -> [String] {
        return indexPaths.compactMap { counters[$0.row] }.map { "\($0.count) x \($0.title ?? "")" }
    }
}

// MARK: - API calls
extension CountersViewModel {
    // MARK: - Fetch counters
    func fetchCounters() {
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
        let selectedCountersIds = indexPaths.compactMap {  indexPath in
            return counters[indexPath.row].id
        }
    }
}

// MARK: - Private methods
extension CountersViewModel {
    // MARK: - Received value handler
    private func receiveValueHandler(_ counters: [Counter]) {
        error = nil
        self.counters = counters
        updateFilteredCounters()
        didUpdateCounters?(totalCountersText)
    }

    // MARK: - Received completion handler
    private func errorHandler(_ error: APIError, in type: ErrorType) {
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

        case .delete:
            title = "Couldn’t delete the counter"

        case .none:
            title = nil
            message = nil
        }

        self.error = (error: error, title: title, message: message, type: type)
        didError?(type)
    }

    private func updateFilteredCounters() {
        guard filteredCounters.count > 0 else { return }

        filteredCounters = filteredCounters.map { filteredCounter in
            return counters.first { $0.id == filteredCounter.id } ?? filteredCounter
        }
    }
}
