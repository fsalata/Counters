//
//  CreateItemViewController.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 28/04/21.
//

import UIKit

class CreateCounterViewController: UIViewController {
    @IBOutlet weak var titleTextField: CustomTextField!
    @IBOutlet weak var examplesButton: UIButton!

    private weak var coordinator: CreateCounterCoordinator?
    private let viewModel: CreateCounterViewModel

    private lazy var cancelBarButtonItem: UIBarButtonItem = {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(dismissViewController))
        cancelButton.tintColor = UIColor(named: .orange)
        return cancelButton
    }()

    private lazy var saveBarButtonItem: UIBarButtonItem = {
        let saveButton = UIBarButtonItem(title: "Save",
                                         style: .done,
                                         target: self,
                                         action: #selector(saveButtonHandler))
        saveButton.tintColor = UIColor(named: .orange)
        saveButton.isEnabled = false
        return saveButton
    }()

    // MARK: - Lifecycle
    init(coordinator: CreateCounterCoordinator, viewModel: CreateCounterViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        setupView()
        bindToViewModel()
    }
}

// MARK: - Private methods
private extension CreateCounterViewController {
    func setupNavigation() {
        title = "Create a counter"
        navigationItem.backButtonTitle = "Create"
        navigationItem.leftBarButtonItems = [cancelBarButtonItem]
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }

    func setupView() {
        titleTextField.delegate = self
        titleTextField.addTarget(self, action: #selector(textFieldTextDidChange(_:)), for: .editingChanged)

        examplesButton.setTitle(CreateCounterStrings.examplesText, for: .normal)

        let hideKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideKeyboardTap)
    }

    func bindToViewModel() {
        viewModel.didSaveCounter = {[weak self] in
            self?.update()
        }
    }

    @objc func dismissViewController() {
        self.coordinator?.dismiss()
    }

    @objc func saveButtonHandler() {
        if let text = titleTextField.text,
           !text.isEmpty {
            hideKeyboard()
            save(title: text)
        }
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    func save(title: String) {
        viewModel.save(title: title)
    }
}

// MARK: Public methods
extension CreateCounterViewController {
    @IBAction func exampleButtonHandler(_ sender: Any) {
        coordinator?.presentExamplesScreen()
    }
}

// MARK: - ViewStateProtocol
private extension CreateCounterViewController {
    func update() {
        DispatchQueue.main.async {
            switch self.viewModel.viewState {
            case .loading:
                self.titleTextField.showLoading()

            case .loaded:
                self.titleTextField.text = nil
                self.titleTextField.hideLoading()
                self.dismissViewController()

            case .error:
                self.titleTextField.hideLoading()
                self.handle(error: .init(title: CreateCounterStrings.ErrorMessage.title,
                                    message: CreateCounterStrings.ErrorMessage.message,
                                    actionButtons: nil))
            }
        }
    }
}

// MARK: - UITextFieldDelegate and methods
extension CreateCounterViewController: UITextFieldDelegate {
    @objc func textFieldTextDidChange(_ textfield: UITextField) {
        self.saveBarButtonItem.isEnabled = !(textfield.text?.isEmpty ?? true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text,
           !text.isEmpty {
            save(title: text)
        }

        hideKeyboard()

        return true
    }
}

// MARK: -
extension CreateCounterViewController: ExamplesViewModelDelegate {
    func examplesViewModel(didSelect item: Example, _ viewModel: ExamplesViewModel) {
        let title = item.name
        titleTextField.text = title.capitalizingFirstLetter()
        save(title: title)
    }
}
