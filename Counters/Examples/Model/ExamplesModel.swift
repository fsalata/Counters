//
//  ExamplesModel.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 21/06/21.
//

import Foundation

struct Example {
    let name: String
}

extension Example {
    static func getExamples() -> [String: [Example]] {
        return  [
                    "drinks": [Example(name: "cups of coffee"),
                               Example(name: "glasses of water"),
                               Example(name: "pints of beer"),
                               Example(name: "Vodka")],

                    "food": [Example(name: "hot-dogs"),
                             Example(name: "cupcakes eaten"),
                             Example(name: "chicken wings")],

                    "misc": [Example(name: "times sneezed"),
                             Example(name: "naps"),
                             Example(name: "day dreaming")]
                ]
    }
}
