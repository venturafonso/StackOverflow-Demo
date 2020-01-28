//
//  AppDelegate.swift
//  stackoverflowusers
//
//  Created by Afonso Coelho on 25/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        let userListCoordinator = UserListCoordinator(withWindow: window)
        userListCoordinator.start()
        return true
    }
}
