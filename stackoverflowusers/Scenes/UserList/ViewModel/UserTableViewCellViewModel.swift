//
//  UserTableViewCellViewModel.swift
//  stackoverflowusers
//
//  Created by Afonso Coelho on 26/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import Foundation

enum UserTableViewCellAction {
    case follow
    case block
}

/// Prevent view from modifying the viewModel
protocol UserTableViewCellViewModelProtocol {
    var name: String { get }
    var reputation: String { get }
    var blocked: Bool { get }
    var followed: Bool { get }
    func loadImage(completion: @escaping ((Result<Data, RequestError>) -> Void))
    func didTapButton(action: UserTableViewCellAction)
}

final class UserTableViewCellViewModel {
    private let user: User
    private let userCellService: UserCellAPI
    private var userBlocked: Bool {
        userPreferencesStoreProtocol.getBlockState(for: user.userId)
    }
    private var userFollowed: Bool {
        userPreferencesStoreProtocol.getFollowState(for: user.userId)
    }
    private var userPreferencesStoreProtocol: UserPreferenceStoreProtocol

    init(user: User, userCellService: UserCellAPI, userPreferencesStore: UserPreferenceStoreProtocol) {
        self.user = user
        self.userCellService = userCellService
        self.userPreferencesStoreProtocol = userPreferencesStore
    }

    private func handleBlockAction() {
        userPreferencesStoreProtocol.toggleBlockState(for: user.userId)
    }

    private func handleFollowAction() {
        userPreferencesStoreProtocol.toggleFollowState(for: user.userId)
    }
}

// MARK: - AlbumCellViewModelProtocol
extension UserTableViewCellViewModel: UserTableViewCellViewModelProtocol {
    func didTapButton(action: UserTableViewCellAction) {
        switch action {
            case .follow:
                handleFollowAction()

            case .block:
                handleBlockAction()
        }
    }

    var name: String {
        return self.user.displayName
    }

    var reputation: String {
        return String(self.user.reputation)
    }

    var blocked: Bool {
        return userBlocked
    }

    var followed: Bool {
        return userFollowed
    }

    func loadImage(completion: @escaping ((Result<Data, RequestError>) -> Void)) {
        let imageURL = user.profileImage
        userCellService.fetchImageData(url: imageURL) { result in
                completion(result)
        }
    }
}
