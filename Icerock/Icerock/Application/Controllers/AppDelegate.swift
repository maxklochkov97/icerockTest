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
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationVC = UINavigationController()
        let repositoriesListVC = RepositoriesListViewController()
        let authVC = AuthViewController()

        if KeyValueStorage.authToken != nil {
            navigationVC.viewControllers = [repositoriesListVC]
        } else {
            navigationVC.viewControllers = [authVC]
        }

        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
        
        return true
    }
}
