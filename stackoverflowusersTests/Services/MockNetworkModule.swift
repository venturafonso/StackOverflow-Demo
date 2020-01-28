//
//  MockNetworkModule.swift
//  stackoverflowusersTests
//
//  Created by Afonso Coelho on 27/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import XCTest
@testable import stackoverflowusers

final class MockNetworkModule {
    private let shouldFail: Bool
    var lastRequestQueryParameters: [URLQueryItem]!
    var lastRequestURL: URL!

    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
}

extension MockNetworkModule: NetworkingProtocol {
    func executeRequest(with baseURL: URL, queryParameters: [URLQueryItem]?, method: HTTPMethod, completion: @escaping (Result<Data, RequestError>) -> Void) {
        lastRequestURL = baseURL
        lastRequestQueryParameters = queryParameters

        if shouldFail {
            completion(.failure(.genericError))
        } else {
            let resourceName = MockUserListDataType.top20.rawValue
            guard let resourceData = Bundle(for: MockUserListService.self).contents(of: resourceName, ofType: "json") else {
                assertionFailure("failed to read contents of resource file \(resourceName)")
                return completion(.failure(.genericError))
            }
            return completion(.success(resourceData))
        }
    }
}
