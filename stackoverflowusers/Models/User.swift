//
//  StackOverflowUser.swift
//  stackoverflowusers
//
//  Created by Afonso Coelho on 25/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import Foundation

struct UserList: Decodable {
    var users: [User]

    private enum CodingKeys: String, CodingKey {
        case users = "items"
    }
}

struct User: Decodable {
    var displayName: String
    var profileImage: URL
    var userId: Int
    var reputation: Int
//    var blocked: Bool = false // Is this state really part of the model? Should we keep in the model just what comes from the outside?
//    var followed: Bool = false // If we stored this state somewhere we would be force to use a custom decoder
//  ☝️ Decided to place these in the viewModel, since the follow/block functionality doesn't need to be coupled to the actual user object
    private enum CodingKeys: String, CodingKey {
        case displayName, profileImage, userId, reputation
    }
}
