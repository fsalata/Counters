//
//  CountersTableViewEditingDataSource.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 12/07/21.
//

import UIKit

class CountersTableViewEditingDataSource: NSObject {
    let counters: [Counter]
    var searchTerm: String?
    weak var viewController: CountersViewController?

    init(_ counters: [Counter], _ viewController: CountersViewController, _ searchTerm: String? = nil) {
        self.counters = counters
        self.viewController = viewController
        self.searchTerm = searchTerm
    }
}

extension CountersTableViewEditingDataSource: UITableViewDataSource {
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
