//
//  AppDelegate.swift
//  Punk
//
//  Created by David Maksa on 27.06.22.
//

import UIKit
import Kingfisher

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureExternalServices()
        window = UIWindow()
        appCoordinator = AppCoordinator()
        window?.rootViewController = appCoordinator?.rootViewController
        appCoordinator?.start()
        window?.makeKeyAndVisible()
        return true
    }
    
    func configureExternalServices() {
        KingfisherManager.shared.downloader.downloadTimeout = 60
    }

}

