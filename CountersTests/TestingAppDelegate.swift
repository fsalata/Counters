//
//  TestingAppDelegate.swift
//  MoodDetectorTests
//
//  Created by Fabio Cezar Salata on 16/04/21.
//

import XCTest
@testable import Counters

@objc(TestingAppDelegate)
class TestingAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: UIViewController())

        window?.makeKeyAndVisible()

        UIView.setAnimationsEnabled(false)

        return true
    }
}
