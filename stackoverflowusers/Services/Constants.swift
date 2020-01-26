//
//  Constants.swift
//  stackoverflowusers
//
//  Created by Afonso Coelho on 25/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

/// Configurations needed to build the URL host/path, everything else is in UserListService. We could of course read these values from a json/.xcconfig etc...
struct StackOverFlowAPIConfiguration {
    static let scheme: HTTPScheme = .https
    static let host: String = "api.stackexchange.com"
    static let version: String = "2.2" //could be an enum with versions and dynamic dependant on the configuration we are loading
    static let numberOfUsersToRequest: Int = 20
}

struct UserServiceConstants {
    struct queryParameterKeys {
        static let order = "order"
        static let sort = "sort"
        static let pageSize = "pageSize"
        static let site = "site"
    }
}

enum ServiceMethod: String {
    case users
    case answers
    case badges
    case comments
    // etc...
}
