//
//  ExamplesViewModel.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 21/06/21.
//

import Foundation

final class ExamplesViewModel {
    let examples: [String: [Example]] = Example.getExamples()

    lazy var sectionKeys: [String] = {
        return Array(examples.keys).sorted(by: <)
    }()
}
