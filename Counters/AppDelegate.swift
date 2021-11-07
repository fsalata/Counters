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

        let factory = DependencyFactory()
        appCoordinator = factory.makeAppCoordinator()
        appCoordinator.start()

        window?.rootViewController = factory.navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
