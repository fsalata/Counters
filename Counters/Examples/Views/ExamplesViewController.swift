//
//  ExamplesViewController.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 21/06/21.
//

import UIKit

class ExamplesViewController: UIViewController {

    //MARK: Properties
    private let coordinator: ExamplesCoordinator
    private let viewModel: ExamplesViewModel

    init(coordinator: ExamplesCoordinator, viewModel: ExamplesViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
