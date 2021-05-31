//
//  FeedbackMessage.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 26/04/21.
//

import Foundation

protocol FeedbackMessage {
    static var title: String { get }
    static var message: String { get }
    static var buttonTitle: String { get }
}
