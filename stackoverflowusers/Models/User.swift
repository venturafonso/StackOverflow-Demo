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
    var profileImage: URL // This should be optional, the app will crash if we try to decode a user without a profileImage.
    var userId: Int
    var reputation: Int
}
