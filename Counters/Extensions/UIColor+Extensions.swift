//
//  UIColor+Extensions.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 14/05/21.
//

import UIKit

enum CustomColors: String {
    case green =  "greenColor"
    case orange = "orangeColor"
    case yellow = "yellowColor"
    case red = "redColor"
    case black = "blackColor"
    case lightGrey = "lightGrey"
    case white = "whiteColor"
    case lighterGrey = "lighterGrey"
}

extension UIColor {

    convenience init?(named: CustomColors) {
        self.init(named: "\(named.rawValue)")
    }

    static func color(named: CustomColors) -> UIColor? {
        return UIColor(named: named.rawValue)
    }
}
