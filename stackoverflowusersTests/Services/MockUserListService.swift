//
//  MockUserListService.swift
//  stackoverflowusersTests
//
//  Created by Afonso Coelho on 27/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import XCTest
@testable import stackoverflowusers

enum MockUserListDataType: String {
    case top20 = "stackOverFlowUserListTop20"
    case bottom20 = "stackOverFlowUserListBottom20"
    case invalidData
}

final class MockUserListService {

    private let mockDataType: MockUserListDataType

    init(mockDataType: MockUserListDataType = .top20) {
        self.mockDataType = mockDataType
    }
}

extension MockUserListService: UserListAPI {
    func fetchTopReputationUsers(amount: Int, completion: @escaping (Result<[User], RequestError>) -> Void) {
        let resourceName = mockDataType.rawValue
        guard let resourceData = Bundle(for: MockUserListService.self).contents(of: resourceName, ofType: "json") else {
            assertionFailure("failed to read contents of resource file \(resourceName)")
            return completion(.failure(.genericError))
        }
        do {
            let userList = try resourceData.decoded() as UserList
            completion(.success(userList.users))
        } catch {
            completion(.failure(.decodingError(error)))
        }
    }

    func fetchLowestReputationUsers(amount: Int, completion: @escaping (Result<[User], RequestError>) -> Void) { }
}
