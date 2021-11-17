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

extension AppDelegate {
    override func handle(error: UIResponder.ErrorMessage, from viewController: UIViewController) {
        let alertController = UIAlertController(title: error.title,
                                                message: error.message,
                                                preferredStyle: error.style)

        error.actionButtons?.forEach { button in
            alertController.addAction(button)
        }

        if let preferredAction = error.actionButtons?.first {
            alertController.preferredAction = preferredAction
        }

        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(dismissAction)

        alertController.view.tintColor = .orange

        DispatchQueue.main.async {
            viewController.present(alertController, animated: true)
        }
    }
}
