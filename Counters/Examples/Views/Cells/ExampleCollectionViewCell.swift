//
//  ExampleCollectionViewCell.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 21/06/21.
//

import UIKit

class ExampleCollectionViewCell: UICollectionViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20)
        ])

        backgroundColor = .white
        layer.cornerRadius = 8
    }

    func configure(example: Example) {
        titleLabel.text = example.name.capitalized
    }
}
