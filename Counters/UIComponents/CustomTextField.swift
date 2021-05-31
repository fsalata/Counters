//
//  CustomTextField.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 28/04/21.
//

import UIKit

class CustomTextField: UITextField {

    private lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.hidesWhenStopped = true
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }

    private func commonInit() {
        tintColor = .orange
        rightView = loadingView
        rightViewMode = .always
        layer.cornerRadius = 8

        rightView?.translatesAutoresizingMaskIntoConstraints = false
        rightView?.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }

    func showLoading() {
        loadingView.startAnimating()
    }

    func hideLoading() {
        loadingView.stopAnimating()
    }
}
