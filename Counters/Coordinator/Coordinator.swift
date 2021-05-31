//
//  Coordinator.swift
//  Counters
//
//  Created by Fabio Cezar Salata on 14/04/21.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }

    func start()
}
