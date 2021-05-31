//
//  FeedbackView.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 25/04/21.
//

import UIKit

protocol FeedbackViewDelegate: AnyObject {
    func feedbackViewDidPerformAction(_ feedbackView: FeedbackView)
}

class FeedbackView: UIView {

    lazy private(set) var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    lazy private(set) var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()

    lazy private(set) var button: Button = {
        let button = Button()
        button.addTarget(self, action: #selector(buttonTapHandler), for: .touchUpInside)
        return button
    }()

    weak var delegate: FeedbackViewDelegate?

    // Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupLayout() {
        let contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        contentStackView.alignment = .center
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(contentStackView)

        contentStackView.addArrangedSubviews(titleLabel, messageLabel, button)

        NSLayoutConstraint.activate([
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            contentStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 36),
            contentStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -36)
        ])
    }

    func configure(title: String?, message: String?, buttonTitle: String?) {
        titleLabel.text = title
        messageLabel.text = message
        button.setTitle(buttonTitle, for: .normal)

        titleLabel.isHidden = title == nil
        messageLabel.isHidden = message == nil
        button.isHidden = buttonTitle == nil
    }

    @objc private func buttonTapHandler() {
        delegate?.feedbackViewDidPerformAction(self)
    }
}
