//
//  CounterNewTableViewCell.swift
//  Counters
//
//  Created by Fabio Salata on 10/04/22.
//

import UIKit

class CounterNewTableViewCell: UITableViewCell {
    private var counter: Counter!
    private var indexPath: IndexPath!

    weak var delegate: CounterTableViewCellDelegate?

    override func updateConfiguration(using state: UICellConfigurationState) {
        var newConfiguration = CounterCellConfiguration().updated(for: state)
        
        newConfiguration.count = "\(counter.count)"
        newConfiguration.title = counter.title
    }
}
