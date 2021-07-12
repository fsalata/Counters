//
//  ExamplesViewController.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 21/06/21.
//

import UIKit

class ExamplesViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: Properties
    private weak var coordinator: ExamplesCoordinator?
    private let viewModel: ExamplesViewModel

    private var examplesCollectionViewDataSource: ExamplesCollectionViewDataSource?

    // MARK: - Lifecycle
    init(coordinator: ExamplesCoordinator, viewModel: ExamplesViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupCollectionView()
    }
}

// MARK: - Private methods
private extension ExamplesViewController {
    func setupNavigation() {
        navigationController?.navigationBar.tintColor = .orange
    }

    func setupCollectionView() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.registerCell(of: ExampleCollectionViewCell.self)
        collectionView.register(ExampleHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: "header",
                                withReuseIdentifier: String(describing: ExampleHeaderCollectionReusableView.self))
        examplesCollectionViewDataSource = ExamplesCollectionViewDataSource(viewModel.examples)
        collectionView.dataSource = examplesCollectionViewDataSource
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(named: .lighterGrey)
    }
}

// MARK: - UICollectionViewDelegate
extension ExamplesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = viewModel.sectionKeys[indexPath.section]
        if let items = viewModel.examples[section] {
            let item = items[indexPath.row]
            viewModel.didSelect(item: item)
            navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - UICollectionView Layout
private extension ExamplesViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .estimated(55))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 16
            section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
            section.orthogonalScrollingBehavior = .continuous

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(40))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
            section.boundarySupplementaryItems = [header]

            return section
        }
    }
}
