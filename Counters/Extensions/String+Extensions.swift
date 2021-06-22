//
//  String+Extensions.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 22/06/21.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
