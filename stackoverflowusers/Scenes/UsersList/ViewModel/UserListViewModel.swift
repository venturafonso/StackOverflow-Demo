//
//  UserListViewModel.swift
//  stackoverflowusers
//
//  Created by Afonso Coelho on 25/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import Foundation

enum viewState {
    case loaded
    case appeared
    case appearing
}

enum UserListViewModelState {
    case loading
    case loaded
    case error
}

protocol UserListViewModelProtocol { //restrict access to the viewModel, make clear the public interface
    var userDataSource: [User]? { get }
    var statusChangedHandler: (() -> Void)? { get set } // binding
    var state: UserListViewModelState { get }
    func userListCellViewModel(for index: Int) -> UserTableViewCellViewModelProtocol
    func viewStateUpdated(_ state: viewState)
}

final class UserListViewModel: UserListViewModelProtocol {
    typealias StatusChangeHandler = (() -> Void)
    
    let userService: UserListAPI
    let userCellService: UserCellAPI
    var statusChangedHandler: StatusChangeHandler?
    var state: UserListViewModelState = .loading {
        didSet {
            statusChangedHandler?()
        }
    }
    var userDataSource: [User]?
    
    private let numberOfUsersToRequest: Int
    
    init(userListService: UserListAPI, userCellService: UserCellAPI, numberOfUsersToRequest: Int) {
        self.userService = userListService
        self.userCellService = userCellService
        self.numberOfUsersToRequest = numberOfUsersToRequest // to avoid a magic number
    }
    
    func viewStateUpdated(_ state: viewState) {
        switch state {
            case .loaded:
                userService.fetchTopReputationUsers(amount: numberOfUsersToRequest) { [weak self] result in
                    self?.handleUserRequestResponse(result)
            }
            case .appeared, .appearing:
                break
        }
    }
    
    func userListCellViewModel(for index: Int) -> UserTableViewCellViewModelProtocol {
        guard let user = userDataSource?[index] else {
            preconditionFailure("Failed to get user from data source on \(self) at index: \(index)")
        }
        return UserTableViewCellViewModel(user: user, userCellService: userCellService)
    }
    
    private func handleUserRequestResponse(_ response: Result<[User], RequestError>) {
        switch response {
            case .success(let userList):
                userDataSource = userList
                state = .loaded
            case.failure(let error):
                state = .error
                print("present error view \(error)")
        }
    }
}
