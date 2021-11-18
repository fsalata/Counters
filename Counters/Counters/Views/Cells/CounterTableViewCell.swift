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
    private var showingNotes = false

    private var notesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    weak var delegate: CounterTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        setupView()
        setupNotesView()
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

    private func setupNotesView() {
        self.notesView.frame = self.containerView.frame
        self.notesView.layer.cornerRadius = 8
        self.notesView.clipsToBounds = true

        let notesTextView = UITextView()
        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        notesTextView.text = "Add notes"
        notesTextView.textColor = .gray

        notesView.addSubview(notesTextView)

        NSLayoutConstraint.activate([
            notesTextView.leftAnchor.constraint(equalTo: notesView.leftAnchor, constant: 8),
            notesTextView.topAnchor.constraint(equalTo: notesView.topAnchor, constant: 8),
            notesTextView.rightAnchor.constraint(equalTo: notesView.rightAnchor, constant: -16),
            notesTextView.bottomAnchor.constraint(equalTo: notesView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with model: Counter, atIndex indexPath: IndexPath) {
        countLabel.text = "\(model.count)"
        titleLabel.text = model.title

        self.indexPath = indexPath
    }

    func toggleNotes() {
        if isSelected {
            UIView.transition(with: self.containerView, duration: 0.5, options: [.transitionFlipFromLeft]) {
                self.containerView.addSubview(self.notesView)

                NSLayoutConstraint.activate([
                    self.notesView.leftAnchor.constraint(equalTo: self.containerView.leftAnchor),
                    self.notesView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
                    self.notesView.rightAnchor.constraint(equalTo: self.containerView.rightAnchor),
                    self.notesView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor)
                ])
            }

            showingNotes = true
        } else {
            if showingNotes {
                UIView.transition(with: self.containerView, duration: 0.5, options: [.transitionFlipFromLeft]) {
                    self.notesView.removeFromSuperview()
                }

                showingNotes = false
            }
        }
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
