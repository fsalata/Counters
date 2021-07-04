//
//  AppDelegate.swift
//  Counters
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let navigationController = UINavigationController()

        appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator.start()

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
