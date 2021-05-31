//
//  RoundCornersView.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 24/04/21.
//

import UIKit

@IBDesignable
class RoundCornersView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

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
        layer.cornerRadius = cornerRadius
    }
}
