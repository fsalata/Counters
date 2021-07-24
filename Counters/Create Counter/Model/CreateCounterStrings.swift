//
//  CreateCounterStrings.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 02/05/21.
//

import Foundation

struct CreateCounterStrings {
    struct ErrorMessage: FeedbackMessage {
        static var title = "Couldn’t create the counter"
        static var message = "The Internet connection appears to be offline."
        static var buttonTitle = "Create a counter"
    }

    static let retryButtontitle = "Retry"
    static let examplesText = "Give it a name. Creative block? See examples."
}
