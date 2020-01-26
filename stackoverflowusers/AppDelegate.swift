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
        // Override point for customization after application launch.
    
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        let userListCoordinator = UserListCoordinator(withWindow: window)
        userListCoordinator.start()
        

//        let networkConfiguration = NetworkConfiguration(cachePolicy: .useProtocolCachePolicy)
//        let networking = NetworkModule(session: URLSession.shared, networkConfiguration:networkConfiguration)
//        guard
//            let userListServiceConfig = UserListServiceConfiguration(scheme: StackOverFlowAPIConfiguration.scheme,
//                                                                          httpMethod: .get,
//                                                                          host: StackOverFlowAPIConfiguration.host,
//                                                                          apiVersion: StackOverFlowAPIConfiguration.version,
//                                                                          method: ServiceMethod.users) else {
//                                                                            return false
//        }
//        let userListService = UserListService(networking: networking, configuration: userListServiceConfig)
//        userListService.fetchTopReputationUsers(amount: 20) { result in
//            switch result {
//                case .success(let users):
//                    print(users)
//
//            case .failure(let error):
//                    print(error)
//            }
//        }
//        let userListViewModel = UserListViewModel(userListService: userListService,
//                                                  numberOfUsersToRequest: StackOverFlowAPIConfiguration.numberOfUsersToRequest)
//        window?.rootViewController = UserListViewController(viewModel: userListViewModel)
//        window?.makeKeyAndVisible()
        return true
    }

    private func setupInitialViewController() {

    }
}
