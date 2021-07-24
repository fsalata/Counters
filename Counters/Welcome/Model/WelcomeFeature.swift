//
//  WelcomeFeature.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 31/05/21.
//

import UIKit

struct WelcomeFeature {
    let badge: UIImage?
    let title: String
    let subtitle: String
}

extension WelcomeFeature {
    static func getFeatures() -> [WelcomeFeature] {
        return [
            .init(badge: UIImage.badge(sytemIcon: "42.circle.fill", color: UIColor(named: .red)),
                  title: "Add almost anything",
                  subtitle: "Capture cups of lattes, frapuccinos, or anything else that can be counted."),
            .init(badge: UIImage.badge(sytemIcon: "person.2.fill", color: UIColor(named: .yellow)),
                  title: "Count to self, or with anyone",
                  subtitle: "Others can view or make changes. There’s no authentication API."),
            .init(badge: UIImage.badge(sytemIcon: "lightbulb.fill", color: UIColor(named: .green)),
                  title: "Count your thoughts",
                  subtitle: "Possibilities are literally endless.")
        ]
    }
}
