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

    convenience init(hex6: UInt32, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let red = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green = CGFloat((hex6 & 0x00FF00) >> 8) / divisor
        let blue = CGFloat(hex6 & 0x0000FF) / divisor
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
