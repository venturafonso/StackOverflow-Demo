//
//  UserListCoordinator.swift
//  stackoverflowusers
//
//  Created by Afonso Coelho on 26/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import Foundation
import UIKit

public protocol Coordinator: class {
    func start()
}

open class UserListCoordinator: Coordinator {
    public let window: UIWindow
    private let networkModule: NetworkModule
    private let userPreferencesStore: UserPreferenceStore = UserPreferenceStore()

    public init(withWindow window: UIWindow) {
        self.window = window

        let networkConfiguration = NetworkConfiguration(cachePolicy: .useProtocolCachePolicy)
        networkModule = NetworkModule(session: URLSession.shared, networkConfiguration:networkConfiguration)
    }

    public func start() {
        guard let userListController = buildUserListController() else {
            fatalError("Failed to build userListController")
        }
        presentUserListController(userListController)
    }

    private func presentUserListController(_ controller: UserListViewController) {
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }

    // MARK: - UserListController initialization boilerplate

    private func buildUserListController() -> UserListViewController? {
        guard let userListServiceConfig = UserListServiceConfiguration(scheme: StackOverFlowAPIConfiguration.scheme,
                                                                       httpMethod: .get,
                                                                       host: StackOverFlowAPIConfiguration.host,
                                                                       apiVersion: StackOverFlowAPIConfiguration.version,
                                                                       method: ServiceMethod.users) else {
                                                                        assertionFailure("Failed to build UserListController")
                                                                        return nil
        }
        let userListService = UserListService(networking: networkModule, configuration: userListServiceConfig)
        let userCellService = ImageFetchingService(networking: networkModule)
        let userListViewModel = UserListViewModel(userListService: userListService, userCellService: userCellService,
                                                  numberOfUsersToRequest: StackOverFlowAPIConfiguration.numberOfUsersToRequest,
                                                  userPreferencesStore: userPreferencesStore)
        return UserListViewController(viewModel: userListViewModel)
    }
}
