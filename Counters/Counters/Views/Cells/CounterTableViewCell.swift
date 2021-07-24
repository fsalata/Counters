//
//  CounterTableViewCell.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 14/05/21.
//

import UIKit

protocol CounterTableViewCellDelegate: AnyObject {
    func counterTableViewCellDidChangeCounter(withAction action: CounterActions, atIndex indexPath: IndexPath)
}

class CounterTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!

    private var indexPath: IndexPath!

    weak var delegate: CounterTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
    }

    private func setupView() {
        tintColor = UIColor(named: .orange)

        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true

        let selectedView = UIView()
        selectedView.backgroundColor = UIColor(named: .lighterGrey)
        self.multipleSelectionBackgroundView = selectedView
        self.selectionStyle = .default
    }

    func configure(with model: Counter, atIndex indexPath: IndexPath) {
        countLabel.text = "\(model.count)"
        titleLabel.text = model.title

        self.indexPath = indexPath
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        segmentControl.isEnabled = !editing
    }

    @IBAction func countChangeHandler(_ sender: UISegmentedControl) {
        if let action = CounterActions(rawValue: sender.selectedSegmentIndex) {
            delegate?.counterTableViewCellDidChangeCounter(withAction: action, atIndex: indexPath)
        }
    }
}
