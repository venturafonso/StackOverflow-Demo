//
//  User.swift
//  stackoverflowusersTests
//
//  Created by Afonso Coelho on 27/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import Foundation

@testable import stackoverflowusers

extension User {
    static let superCoolUser = User(
        displayName: "John AppleSeed",
        profileImage: URL(string: "https://www.gravatar.com/avatar/4e28027a2833fb1eff07ad7d70df46d8?s=128&d=identicon&r=PG")!,
        userId: 2682,
        reputation: 1)
}
