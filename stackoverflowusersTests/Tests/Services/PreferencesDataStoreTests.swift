//
//  PreferencesDataStoreTest.swift
//  stackoverflowusersTests
//
//  Created by Afonso Coelho on 27/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import XCTest
@testable import stackoverflowusers

final class PreferencesDataStoreTest: XCTestCase {

    func test_block_user() {

        // Given
        let preferenceDataStore = UserPreferenceStore()

        // When
        preferenceDataStore.toggleBlockState(for: 1)

        // Then
        XCTAssertTrue(preferenceDataStore.getBlockState(for: 1))
    }

    func test_block_should_unfollow() {
        // Given
        let preferenceDataStore = UserPreferenceStore()

        // When
        preferenceDataStore.toggleFollowState(for: 1)
        preferenceDataStore.toggleBlockState(for: 1)

        // Then
        XCTAssertFalse(preferenceDataStore.getFollowState(for: 1))
    }

    func test_follow() {
        // Given
        let preferenceDataStore = UserPreferenceStore()

        // When
        preferenceDataStore.toggleFollowState(for: 1)

        // Then
        XCTAssertTrue(preferenceDataStore.getFollowState(for: 1))
    }

    func test_follow_unfollow() {
        // Given
        let preferenceDataStore = UserPreferenceStore()

        // When
        preferenceDataStore.toggleFollowState(for: 1)
        preferenceDataStore.toggleFollowState(for: 1)

        // Then
        XCTAssertFalse(preferenceDataStore.getFollowState(for: 1))
    }
}
