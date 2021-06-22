//
//  ExamplesViewModel.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 21/06/21.
//

import Foundation

protocol ExamplesViewModelDelegate: AnyObject {
    func examplesViewModel(didSelect item: Example, _ viewModel: ExamplesViewModel)
}

final class ExamplesViewModel {
    let examples: [String: [Example]] = Example.getExamples()

    weak var delegate: ExamplesViewModelDelegate?

    lazy var sectionKeys: [String] = {
        return Array(examples.keys).sorted(by: <)
    }()

    func didSelect(item: Example) {
        delegate?.examplesViewModel(didSelect: item, self)
    }
}
