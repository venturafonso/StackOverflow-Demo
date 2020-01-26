//
//  UserTableViewCellViewModel.swift
//  stackoverflowusers
//
//  Created by Afonso Coelho on 26/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import Foundation

/// Protocol to be esposed to view controller
protocol UserTableViewCellViewModelProtocol {
    var name: String { get }
    var reputation: String { get }
    func loadImage(completion: @escaping ((Result<Data, RequestError>) -> Void))
}

final class UserTableViewCellViewModel {
    private let user: User
    private let userCellService: UserCellAPI
    // private var imageData: Data?
    
    init(user: User, userCellService: UserCellAPI) {
        self.user = user
        self.userCellService = userCellService
    }
}

// MARK: - AlbumCellViewModelProtocol
extension UserTableViewCellViewModel: UserTableViewCellViewModelProtocol {
    var name: String {
        return self.user.displayName
    }
    
    var reputation: String {
        return String(self.user.reputation)
    }
    
    func loadImage(completion: @escaping ((Result<Data, RequestError>) -> Void)) {
        let imageURL = user.profileImage
        userCellService.fetchImageData(url: imageURL) { result in
                completion(result)
        }
    }
}
