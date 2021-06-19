//
//  CountersViewController.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 14/05/21.
//

import UIKit

class CountersViewController: UIViewController {
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

    private var isSearchEmpty: Bool {
        return viewModel.isFilteredCountersEmpty
    }

    private var isSearching: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
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
        viewModel.didChangeState = {[weak self] viewState, totalCountString, error in
            self?.update(viewState, totalCountString, error)
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
        return isSearching ? viewModel.filteredCounters.count : viewModel.counters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueCell(of: CounterTableViewCell.self, for: indexPath) { [weak self] cell in
            guard let self = self else { return }

            let counter = self.isSearching ? self.viewModel.filteredCounters[indexPath.row]
                                           : self.viewModel.counters[indexPath.row]

            cell.configure(with: counter, atIndex: indexPath)

            cell.delegate = self
        }
    }
}

// MARK: - CounterTableViewCellDelegate
extension CountersViewController: CounterTableViewCellDelegate {
    func counterTableViewCellDidChangeCounter(withAction action: CounterActions, atIndex indexPath: IndexPath) {
        let counter = isSearching ? viewModel.filteredCounters[indexPath.row] : viewModel.counters[indexPath.row]

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
        viewModel.didEndFiltering()
    }
}

// MARK: - UISearchResultsUpdating
extension CountersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }

        viewModel.filterCounters(title: text)
    }
}

// MARK: - FeedbackViewDelegate
extension CountersViewController: FeedbackViewDelegate {
    func feedbackViewDidPerformAction(_ feedbackView: FeedbackView) {
        guard case .error(_) = viewModel.viewState else {
            presentCreateCounter()
            return
        }

        fetchCounters()
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

    func update(_ viewState: CountersViewModel.ViewStateVM,
                _ totalCountString: String,
                _ error: CountersViewModel.ViewStateError?) {
        print("=== Current state: \(viewState) ===")

        DispatchQueue.main.async {
            self.tableView.backgroundView = nil

            switch viewState {
            // MARK: - Loading
            case .loading:
                self.tableView.backgroundView = self.loadingIndicator
                self.loadingIndicator.startAnimating()

            // MARK: - Has Content
            case .hasContent:
                self.tableView.reloadData()

            // MARK: - No Content
            case .noContent:
                if self.isCountersEmpty {
                    self.feedbackView.configure(title: CounterStrings.EmptyMessage.title,
                                                message: CounterStrings.EmptyMessage.message,
                                                buttonTitle: CounterStrings.EmptyMessage.buttonTitle)

                    self.tableView.backgroundView = self.feedbackView
                }

                self.tableView.reloadData()

            // MARK: - Searching
            case .searching:
                if self.isSearchEmpty && !(self.searchController.searchBar.text?.isEmpty ?? true) {
                    self.feedbackView.configure(title: nil,
                                                message: "No results",
                                                buttonTitle: nil)

                    self.tableView.backgroundView = self.feedbackView
                }

                self.tableView.reloadData()

            // MARK: - Error
            case .error:
                self.tableView.reloadData()

                guard let error = error else { return }

                guard error.type != .fetch else {
                    guard let title = error.title,
                          let message = error.message else { return }

                    self.feedbackView.configure(title: title,
                                                message: message,
                                                buttonTitle: CounterStrings.retryButtontitle)
                    self.tableView.backgroundView = self.feedbackView
                    return
                }

                self.handleError(title: error.title, message: error.message, type: error.type)
            }

            self.loadingIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
            self.updateButtonsState()
            self.totalCountLabel.text = totalCountString
        }
    }

    // MARK: - Error handler
    private func handleError(title: String?, message: String?, type: CountersViewModel.ViewErrorType) {
        var actionButtons: [UIAlertAction] = []

        switch type {
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
