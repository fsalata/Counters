//
//  CreateItemViewModel.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 28/04/21.
//

import Foundation
import Combine

final class CreateCounterViewModel {
    private let service: CountersService

    // Init
    init(service: CountersService = CountersService()) {
        self.service = service
    }

    // MARK: - Fetch Counters
    func save(title: String, completion: @escaping (Result<[Counter], APIError>, URLResponse?) -> Void) {
        service.save(title: title, completion: completion)
    }
}
