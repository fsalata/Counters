//
//  WelcomeViewModel.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 24/04/21.
//

import Foundation

final class WelcomeViewModel {
    let features: [WelcomeFeature]

    init(features: [WelcomeFeature] = WelcomeFeature.getFeatures()) {
        self.features = features
    }
}

