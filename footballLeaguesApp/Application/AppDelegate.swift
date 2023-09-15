//
//  AppDelegate.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 27/04/2022.
//

import UIKit

@available(iOS 15.0.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let injectionContainer = HomeDependencyContainer()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let mainVC = injectionContainer.makeHomeViewController()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = mainVC
        window?.makeKeyAndVisible()
//        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
//        }

        return true
    }

}

