//
//  WelcomeViewController.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 24/04/21.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var continueButton: Button!

    private weak var coordinator: WelcomeCoordinator?
    private let viewModel: WelcomeViewModel

    init(coordinator: WelcomeCoordinator, viewModel: WelcomeViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupContent()
    }

    @IBAction func continueButtonHandler(_ sender: Any) {
        coordinator?.dismiss()
    }
}

// MARK: - Private methods
private extension WelcomeViewController {
    func setupContent() {
        for feature in viewModel.features {
            configure(feature)
        }
    }

    func configure(_ feature: WelcomeFeature) {
        let containerStackView = UIStackView()
        containerStackView.axis = .horizontal
        containerStackView.alignment = .top
        containerStackView.spacing = 16

        let badgeImageView = UIImageView()
        badgeImageView.translatesAutoresizingMaskIntoConstraints = false
        badgeImageView.contentMode = .center

        let titleLabel = UILabel()
        titleLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: .systemFont(ofSize: 17,
                                                                                             weight: .semibold))

        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: .systemFont(ofSize: 17,
                                                                                               weight: .regular))
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = UIColor(named: "DescriptionText")

        let innerStackView = UIStackView()
        innerStackView.axis = .vertical
        innerStackView.alignment = .leading

        badgeImageView.image = feature.badge
        titleLabel.text = feature.title
        descriptionLabel.text = feature.subtitle

        innerStackView.addArrangedSubviews(titleLabel, descriptionLabel)

        containerStackView.addArrangedSubviews(badgeImageView, innerStackView)

        badgeImageView.widthAnchor.constraint(equalToConstant: 49).isActive = true
        badgeImageView.heightAnchor.constraint(equalToConstant: 49).isActive = true

        contentStackView.addArrangedSubview(containerStackView)
    }
}
