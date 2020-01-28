//
//  UserListServiceTests.swift
//  stackoverflowusersTests
//
//  Created by Afonso Coelho on 28/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import XCTest
@testable import stackoverflowusers

final class UserListServiceTests: XCTestCase {

    func test_request_failure() {

        // Given
        let mockServiceConfiguration = UserListServiceConfiguration(scheme: .https, httpMethod: .get, host: "google.com", apiVersion: "1", method: .users)!
        let shouldFailRequests = true
        let userListService = UserListService(networking: MockNetworkModule(shouldFail: shouldFailRequests), configuration: mockServiceConfiguration)

        // When
        let exp = expectation(description: "Request should fail with error")
        userListService.fetchTopReputationUsers(amount: 20) { result in
            switch result {
                case .success:
                 XCTFail("Unexpected request result")
                case .failure:
                    exp.fulfill()
            }
        }

        // Then
        wait(for: [exp], timeout: 1.0)
    }

    func test_request_success() {
        // Given
        let mockServiceConfiguration = UserListServiceConfiguration(scheme: .https, httpMethod: .get, host: "google.com", apiVersion: "1", method: .users)!
        let shouldFailRequests = false
        let userListService = UserListService(networking: MockNetworkModule(shouldFail: shouldFailRequests), configuration: mockServiceConfiguration)

        //When
        let exp = expectation(description: "Request should fail with error")
        userListService.fetchTopReputationUsers(amount: 20) { result in
            switch result {
                case .success:
                    exp.fulfill()
                case .failure:
                    XCTFail("Unexpected request result")
            }
        }

        //Then
        wait(for: [exp], timeout: 1.0)
    }

    func test_query_param_builder_pageSize_value_matches() {

        // Given
        let mockServiceConfiguration = UserListServiceConfiguration(scheme: .https, httpMethod: .get, host: "google.com", apiVersion: "1", method: .users)!
        let shouldFailRequests = true
        let mockNetworkModule = MockNetworkModule(shouldFail: shouldFailRequests)
        let userListService = UserListService(networking: mockNetworkModule, configuration: mockServiceConfiguration)
        let userAmount: Int = 50

        // When
        userListService.fetchTopReputationUsers(amount: 50) { _ in }

        // Then
        let pageSizeQueryParam = mockNetworkModule.lastRequestQueryParameters.first(where: { $0.name == UserServiceConstants.queryParameterKeys.pageSize && $0.value == String(userAmount) })
        XCTAssertNotNil(pageSizeQueryParam)
    }

    func test_service_configuration_host_matches_request_url_host() {

        // Given
        let mockHost = "google.com"
        let mockServiceConfiguration = UserListServiceConfiguration(scheme: .https, httpMethod: .get, host: "google.com", apiVersion: "1", method: .users)!
        let mockNetworkModule = MockNetworkModule()
        let userListService = UserListService(networking: mockNetworkModule, configuration: mockServiceConfiguration)

        // When
        userListService.fetchTopReputationUsers(amount: 50) { _ in }

        // Then
            XCTAssertEqual(mockNetworkModule.lastRequestURL.host, mockHost)
    }
}
