//
//  AppDelegate.swift
//  Icerock
//
//  Created by Максим Клочков on 13.05.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        NetworkMonitor.shared.startMonitoring()

        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationVC = UINavigationController()
        let authVC = AuthViewController()
        navigationVC.viewControllers = [authVC]

        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()

        return true
    }
}
