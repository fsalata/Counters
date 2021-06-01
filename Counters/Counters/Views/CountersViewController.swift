//
//  CountersViewController.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 14/05/21.
//

import UIKit

class CountersViewController: UIViewController, ViewStateProtocol {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addNewButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var totalCountLabel: UILabel!

    //MARK: Properties
    private let coordinator: CountersCoordinator
    private let viewModel: CountersViewModel

    private lazy var searchController: UISearchController = {
        UISearchController(searchResultsController: nil)
    }()

    private lazy var feedbackView: FeedbackView = {
        let feedbackView = FeedbackView()
        feedbackView.delegate = self
        return feedbackView
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        UIActivityIndicatorView(style: .large)
    }()

    private lazy var editBarButtonItem: UIBarButtonItem = {
        let editButton = self.editButtonItem
        editButton.tintColor = UIColor(named: .orange)
        editButton.isEnabled = false
        return editButton
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchCounters), for: .valueChanged)
        return refreshControl
    }()

    private lazy var selectAllBarButtonItem: UIBarButtonItem = {
        let selectAllButton = UIBarButtonItem(title: "Select All",
                                              style: .plain,
                                              target: self,
                                              action: #selector(selectAllHandler))
        selectAllButton.tintColor = UIColor(named: .orange)
        return selectAllButton
    }()

    private var isCountersEmpty: Bool {
        return viewModel.isCountersEmpty
    }

    private var isFilterEmpty: Bool {
        return viewModel.isFilteredCountersEmpty
    }

    private var isFiltering: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }

    var state: ViewState = .loading {
        didSet {
            update()
        }
    }

    // MARK: - Init
    init(coordinator: CountersCoordinator, viewModel: CountersViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupTableView()
        bindToViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchCounters()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        checkFirstTimeUse()
    }

    private func setupNavigation() {
        title = "Counters"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItems = [editBarButtonItem]
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        UIBarButtonItem
            .appearance(whenContainedInInstancesOf: [UISearchBar.self])
            .setTitleTextAttributes([.foregroundColor: UIColor.orange],
                                    for: .normal)
    }

    private func setupTableView() {
        tableView.registerCell(of: CounterTableViewCell.self)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.contentInset.top = 8
        tableView.refreshControl = refreshControl
    }

    // MARK: - Subscriptions
    private func bindToViewModel() {
        viewModel.didUpdateCounters = { [weak self] totalCountersText in
            self?.state = .loaded(message: totalCountersText)
        }

        viewModel.didError = { [weak self] errorType in
            self?.state = .error(errorType: errorType)
        }
    }

    private func checkFirstTimeUse() {
        if viewModel.checkFirstTimeUse() {
            coordinator.presentWelcomeScreen()
        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        tableView.setEditing(editing, animated: true)

        updateButtonsState()
    }

    // MARK: - Private methods
    private func checkIfEmptyList() {
        DispatchQueue.main.async {
            switch self.state {
            case .loaded where self.isCountersEmpty:
                self.feedbackView.configure(title: CounterStrings.EmptyMessage.title,
                                            message: CounterStrings.EmptyMessage.message,
                                            buttonTitle: CounterStrings.EmptyMessage.buttonTitle)

                self.tableView.backgroundView = self.feedbackView

            case .filtering where self.isFilterEmpty && !(self.searchController.searchBar.text?.isEmpty ?? true):
                self.feedbackView.configure(title: nil,
                                            message: "No results",
                                            buttonTitle: nil)

                self.tableView.backgroundView = self.feedbackView

            case .error:
                break

            default:
                self.tableView.backgroundView = nil
            }

        }
    }

    @objc private func selectAllHandler() {
        for row in 0..<viewModel.counters.count {
            let indexPath = IndexPath(row: row, section: 0)

            self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
    }

    private func presentCreateCounter() {
        coordinator.presentCreateItem()
    }

    // MARK: - Fetch data
    @objc private func fetchCounters() {
        state = .loading
        viewModel.fetchCounters()
    }

    // MARK: - Actions
    @IBAction func createItemHandler(_ sender: Any) {
        presentCreateCounter()
    }

    @IBAction func deleteItemHandler(_ sender: Any) {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else {
            return
        }

        let title = "Delete \(selectedIndexPaths.count) counter\(selectedIndexPaths.count > 0 ? "s" : "")"
        let deleteAction = UIAlertAction(title: title,
                                         style: .destructive) { _ in
            self.viewModel.deleteCounters(at: selectedIndexPaths) {
                DispatchQueue.main.async {
                    self.setEditing(!self.isCountersEmpty, animated: true)
                }
            }

        }

        showAlert(title: nil, message: nil, actionButtons: [deleteAction], style: .actionSheet)
    }

    @IBAction func shareItemHandler(_ sender: Any) {
        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else {
            return
        }

        let itemsToShare = viewModel.shareItems(at: selectedIndexPaths)

        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        navigationController!.present(activityViewController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension CountersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkIfEmptyList()

        return isFiltering ? viewModel.filteredCounters.count : viewModel.counters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueCell(of: CounterTableViewCell.self, for: indexPath) { [weak self] cell in
            guard let self = self else { return }

            let counter = self.isFiltering ? self.viewModel.filteredCounters[indexPath.row]
                                           : self.viewModel.counters[indexPath.row]

            cell.configure(with: counter, atIndex: indexPath)

            cell.delegate = self
        }
    }
}

// MARK: - CounterTableViewCellDelegate
extension CountersViewController: CounterTableViewCellDelegate {
    func counterTableViewCellDidChangeCounter(withAction action: CounterActions, atIndex indexPath: IndexPath) {
        let counter = isFiltering ? viewModel.filteredCounters[indexPath.row] : viewModel.counters[indexPath.row]

        switch action {
        case .increment:
            viewModel.incrementCounter(counter)
        case .decrement:
            viewModel.decrementCounter(counter)
        }
    }
}

// MARK: - UISearchDelegate
extension CountersViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.state = .loaded(message: nil)
            self.tableView.reloadData()
        }
    }
}

// MARK: - UISearchResultsUpdating
extension CountersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }

        if isFiltering && state != .filtering {
            state = .filtering
        }

        viewModel.filterCounters(title: text) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - FeedbackViewDelegate
extension CountersViewController: FeedbackViewDelegate {
    func feedbackViewDidPerformAction(_ feedbackView: FeedbackView) {
        guard viewModel.error == nil else {
            fetchCounters()
            return
        }

        presentCreateCounter()
    }
}

// MARK: - View States
extension CountersViewController {
    private func updateButtonsState() {
        editButtonItem.isEnabled = !isCountersEmpty || isEditing
        totalCountLabel.isHidden = isCountersEmpty
        addNewButton.isHidden = isEditing
        deleteButton.isHidden = !isEditing
        shareButton.isHidden = !isEditing

        searchController.searchBar.isUserInteractionEnabled = !isCountersEmpty && !isEditing
        searchController.searchBar.alpha = (isCountersEmpty || isEditing) ? 0.5 : 1

        navigationItem.rightBarButtonItem = isEditing ? selectAllBarButtonItem : nil
    }

    func update() {
        print("=== Current state: \(state) ===")

        DispatchQueue.main.async {
            self.tableView.backgroundView = nil
            self.loadingIndicator.stopAnimating()
            self.refreshControl.endRefreshing()

            self.updateButtonsState()

            switch self.state {
            // MARK: Loading
            case .loading:
                self.tableView.backgroundView = self.loadingIndicator
                self.loadingIndicator.startAnimating()

            // MARK: Loaded
            case .loaded(let totalCountText):
                self.tableView.reloadData()
                self.totalCountLabel.text = totalCountText

            // MARK: Error
            case .error:
                self.tableView.reloadData()

                guard let (_, title, message, target) = self.viewModel.error else { return }

                guard target != .fetch else {
                    guard let title = title,
                          let message = message else { return }

                    self.feedbackView.configure(title: title,
                                                message: message,
                                                buttonTitle: CounterStrings.retryButtontitle)
                    self.tableView.backgroundView = self.feedbackView
                    return
                }

                self.handleError(title: title, message: message, target: target)

            default:
                break
            }
        }
    }

    // MARK: - Error handler
    private func handleError(title: String?, message: String?, target: ErrorType) {
        var actionButtons: [UIAlertAction] = []

        switch target {
        case .fetch:
            let retryAction = UIAlertAction(title: CounterStrings.retryButtontitle, style: .default) { _ in
                self.fetchCounters()
            }
            actionButtons.append(retryAction)

        case .increment(let counter):
            let retryAction = UIAlertAction(title: CounterStrings.retryButtontitle, style: .default) { _ in
                self.viewModel.incrementCounter(counter)
            }
            actionButtons.append(retryAction)

        case .decrement(let counter):
            let retryAction = UIAlertAction(title: CounterStrings.retryButtontitle, style: .default) { _ in
                self.viewModel.decrementCounter(counter)
            }
            actionButtons.append(retryAction)

        default:
            break
        }

        self.showAlert(title: title, message: message, actionButtons: actionButtons)
    }
}
