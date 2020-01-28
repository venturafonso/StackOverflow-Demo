//
//  UserTableViewCellViewModelTests.swift
//  stackoverflowusersTests
//
//  Created by Afonso Coelho on 28/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import XCTest
@testable import stackoverflowusers

final class UserTableViewCellViewModelTests: XCTestCase {

    func test_viewModel_sets_user_data_correctly() {
        // Given
        let user = User.superCoolUser
        let cellViewModel = UserTableViewCellViewModel(user: user, userCellService: MockImageFetchingService(), userPreferencesStore: MockUserPreferenceStore())

        // Then
        XCTAssertEqual(cellViewModel.name, user.displayName)
        XCTAssertEqual(cellViewModel.reputation, String(user.reputation))
    }

    func test_viewModel_reacts_to_button_taps() {

        // Given
        let user = User.superCoolUser
        let mockUserPreferencesStore = MockUserPreferenceStore()
        let cellViewModel = UserTableViewCellViewModel(user: user, userCellService: MockImageFetchingService(), userPreferencesStore: mockUserPreferencesStore)

        // When
        cellViewModel.didTapButton(action: .block)
        cellViewModel.didTapButton(action: .follow)

        // Then
        XCTAssertTrue(mockUserPreferencesStore.toggleBlockCalled)
        XCTAssertTrue(mockUserPreferencesStore.toggleFollowCalled)
    }

    func test_fetch_avatar_image_gets_success_result() {
        // Given
        let user = User.superCoolUser
        let mockUserPreferencesStore = MockUserPreferenceStore()
        let requestShouldFail = false
        let cellViewModel = UserTableViewCellViewModel(user: user, userCellService: MockImageFetchingService(requestShouldFail), userPreferencesStore: mockUserPreferencesStore)
        let exp = expectation(description: "LoadImage should return success with data")

        // When
        cellViewModel.loadImage { result in
            switch result {
                case .success:
                    exp.fulfill()
                case .failure:
                XCTFail("Unexpected result on cellViewModel.loadImage")
            }
        }

        // Then
        wait(for: [exp], timeout: 1.0)
    }

    func test_fetch_avatar_image_gets_failure_result() {
        // Given
        let user = User.superCoolUser
        let mockUserPreferencesStore = MockUserPreferenceStore()
        let requestShouldFail = true
        let cellViewModel = UserTableViewCellViewModel(user: user,
                                                       userCellService: MockImageFetchingService(requestShouldFail),
                                                       userPreferencesStore: mockUserPreferencesStore)
        let exp = expectation(description: "LoadImage should return error")

        // When
        cellViewModel.loadImage { result in
            switch result {
                case .success:
                    XCTFail("Unexpected result on cellViewModel.loadImage")
                case .failure:
                    exp.fulfill()
            }
        }

        // Then
        wait(for: [exp], timeout: 1.0)
    }
}
