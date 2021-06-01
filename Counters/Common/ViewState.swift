//
//  ViewState.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 26/04/21.
//

import UIKit

enum ViewState: Equatable {
    case loading
    case loaded(message: String?)
    case error(errorType: ErrorType)
    case filtering
}

protocol ViewStateProtocol {
    var state: ViewState { get }

    func update()
}

enum ErrorType: Equatable {
    case fetch
    case increment(_ counter: Counter)
    case decrement(_ counter: Counter)
    case delete(_ counter: Counter)
    case none
}
