//
//  UserListViewModel.swift
//  stackoverflowusers
//
//  Created by Afonso Coelho on 25/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import Foundation

enum viewState {
    case didLoad
    case willAppear
    case errored
}

enum UserListViewModelState {
    case loading
    case loaded
    case error(Error)
}

protocol UserListViewModelProtocol { //restrict access to the viewModel, make clear the public interface
    var userDataSource: [User]? { get }
    var statusChangedHandler: (() -> Void)? { get set } // binding
    var viewModelState: UserListViewModelState { get }
    func userListCellViewModel(for index: Int) -> UserTableViewCellViewModelProtocol
    func viewStateUpdated(_ state: viewState)
}

final class UserListViewModel: UserListViewModelProtocol {
    typealias StatusChangeHandler = (() -> Void)
    
    let userService: UserListAPI
    let userCellService: UserCellAPI
    var userDataSource: [User]?
    var statusChangedHandler: StatusChangeHandler?
    var viewModelState: UserListViewModelState = .loading {
        didSet {
            statusChangedHandler?()
        }
    }
    private let userPreferencesStore: UserPreferenceStoreProtocol
    private let numberOfUsersToRequest: Int
    
    init(userListService: UserListAPI,
         userCellService: UserCellAPI,
         numberOfUsersToRequest: Int,
         userPreferencesStore: UserPreferenceStoreProtocol) {
        self.userService = userListService
        self.userCellService = userCellService
        self.numberOfUsersToRequest = numberOfUsersToRequest
        self.userPreferencesStore = userPreferencesStore// to avoid a magic number
    }
    
    func viewStateUpdated(_ viewState: viewState) {
        switch viewState {
            case .didLoad, .errored:
                requestTopUsers()
            case .willAppear:
                break
        }
    }
    
    func userListCellViewModel(for index: Int) -> UserTableViewCellViewModelProtocol {
        guard let user = userDataSource?[index] else {
            preconditionFailure("Failed to get user from data source on \(self) at index: \(index)")
        }
        return UserTableViewCellViewModel(user: user, userCellService: userCellService, userPreferencesStore: userPreferencesStore)
    }
    
    private func requestTopUsers() {
        userService.fetchTopReputationUsers(amount: numberOfUsersToRequest) { [weak self] result in
            self?.handleUserRequestResponse(result)
        }
    }
    
    private func handleUserRequestResponse(_ response: Result<[User], RequestError>) {
        switch response {
            case .success(let userList):
                userDataSource = userList
                viewModelState = .loaded
            case.failure(let error):
                viewModelState = .error(error)
        }
    }
}
