//
//  FeedbackModel.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 14/05/21.
//

import Foundation

struct CounterStrings {
    struct EmptyMessage: FeedbackMessage {
        static var title = "No counters yet"
        static var message = "\"When I started counting my blessings, my whole life turned around.\" \n—Willie Nelson"
        static var buttonTitle = "Create a counter"
    }

    static let retryButtontitle = "Retry"
}
