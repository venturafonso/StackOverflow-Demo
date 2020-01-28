//
//  MockUserPreferenceStore.swift
//  stackoverflowusersTests
//
//  Created by Afonso Coelho on 27/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import XCTest
@testable import stackoverflowusers

final class MockUserPreferenceStore {
    var toggleBlockCalled: Bool = false
    var toggleFollowCalled: Bool = false
}

extension MockUserPreferenceStore: UserPreferenceStoreProtocol {
    func toggleBlockState(for id: Int) {
        toggleBlockCalled = true
    }

    func toggleFollowState(for id: Int) {
        toggleFollowCalled = true
    }

    func getBlockState(for id: Int) -> Bool {
        return false
    }

    func getFollowState(for id: Int) -> Bool {
        return false
    }
}
