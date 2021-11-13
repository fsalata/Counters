//
//  CountersTableViewDataSource.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 12/07/21.
//

import UIKit

final class CountersTableViewDataSource: NSObject {
    private weak var viewController: CountersViewController?
    private let counters: [Counter]

    init(_ viewController: CountersViewController, _ counters: [Counter]) {
        self.counters = counters
        self.viewController = viewController
    }
}

extension CountersTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueCell(of: CounterTableViewCell.self, for: indexPath) { [weak self] cell in
            guard let self = self else { return }

            let counter = self.counters[indexPath.row]

            cell.configure(with: counter, atIndex: indexPath)

            cell.delegate = self.viewController
        }
    }
}
