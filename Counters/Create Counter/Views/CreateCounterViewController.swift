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

    private let coordinator: CreateCounterCoordinator
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

    // MARK: - Init
    init(coordinator: CreateCounterCoordinator, viewModel: CreateCounterViewModel) {
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

        setupNavigation()
        setupView()
        bindToViewModel()
    }

    private func setupNavigation() {
        title = "Create a counter"
        navigationItem.backButtonTitle = "Create"
        navigationItem.leftBarButtonItems = [cancelBarButtonItem]
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }

    private func setupView() {
        titleTextField.delegate = self
        titleTextField.addTarget(self, action: #selector(textFieldTextDidChange(_:)), for: .editingChanged)

        examplesButton.setTitle(CreateCounterStrings.examplesText, for: .normal)

        let hideKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideKeyboardTap)
    }

    private func bindToViewModel() {
        viewModel.didSaveCounter = {[weak self] in
            self?.update()
        }
    }

    @objc private func dismissViewController() {
        DispatchQueue.main.async {
            self.navigationController?.dismiss(animated: true)
        }
    }

    @objc private func saveButtonHandler() {
        if let text = titleTextField.text,
           !text.isEmpty {
            hideKeyboard()
            save(title: text)
        }
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

    private func save(title: String) {
        viewModel.save(title: title)
    }

    @IBAction func exampleButtonHandler(_ sender: Any) {
        coordinator.presentExamplesScreen()
    }
}

// MARK: - ViewStateProtocol
extension CreateCounterViewController {
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
                self.handleError()
            }
        }
    }

    private func handleError() {
        DispatchQueue.main.async {
            self.showAlert(title: CreateCounterStrings.ErrorMessage.title,
                           message: CreateCounterStrings.ErrorMessage.message,
                           actionButtons: nil)
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

// MARK: - UITextViewDelegate
extension CreateCounterViewController: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        print("textview button pressed")
        return false
    }
}
