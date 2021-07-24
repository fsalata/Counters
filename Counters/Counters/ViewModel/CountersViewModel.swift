//
//  CountersViewModel.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 14/05/21.
//

import Foundation

final class CountersViewModel: ObservableObject {
    private let storageProvider: StorageProvider
    private let userDefaults: UserDefaultsProtocol

    private(set) var counters: [Counter] = []
    private(set) var filteredCounters: [Counter] = []
    private let firstTimeOpenKey = "FirstOpen"

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

    // View bindings
    var didChangeState: ((ViewState, ViewStateError?) -> Void)?

    // Init
    init(storageProvider: StorageProvider = StorageProvider(),
         userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.storageProvider = storageProvider
        self.userDefaults = userDefaults
    }
}

// MARK: - Public methods
extension CountersViewModel {
    func checkFirstTimeUse() -> Bool {
        if getValueFor(key: firstTimeOpenKey) == nil {
            set(value: false, for: firstTimeOpenKey)
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

        let counters = storageProvider.getCounters()

        self.receiveValueHandler(counters)
    }

    // MARK: - Increment counter
    func incrementCounter(_ counter: Counter) {
        counter.count += 1
        storageProvider.updateCounter(counter)
        fetchCounters()
    }

    // MARK: - Decrement counter
    func decrementCounter(_ counter: Counter) {
        guard counter.count > 0 else { return }

        counter.count -= 1
        storageProvider.updateCounter(counter)
        fetchCounters()
    }

    // MARK: - Delete counter(s)
    func deleteCounters(at indexPaths: [IndexPath], completion: @escaping () -> Void) {
        viewState = .loading

        let selectedCounters = indexPaths.compactMap {  indexPath in
            return counters[indexPath.row]
        }

        storageProvider.deleteCounter(selectedCounters)
        fetchCounters()

        completion()
    }
}

// MARK: - Private methods
private extension CountersViewModel {
    // Received value handler
    func receiveValueHandler(_ counters: [Counter]) {
        self.counters = counters
        updateFilteredCounters()
        viewState = counters.isEmpty ? .noContent : .hasContent
    }

    func updateFilteredCounters() {
        guard filteredCounters.count > 0 else { return }

        filteredCounters = filteredCounters.map { filteredCounter in
            return counters.first { $0.id == filteredCounter.id } ?? filteredCounter
        }
    }

    // MARK: UserDefaults
    func getValueFor(key: String) -> Bool? {
        userDefaults.object(forKey: firstTimeOpenKey) as? Bool
    }

    func set(value: Bool, for key: String) {
        userDefaults.setValue(false, forKey: firstTimeOpenKey)
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
