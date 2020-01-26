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

    enum CodingKeys: String, CodingKey {
        case users = "items"
    }
}

struct User: Decodable {
    var displayName: String
    var profileImage: URL
    var userId: Int
    var reputation: Int
}
