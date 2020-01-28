//
//  UserListViewModelTests.swift
//  stackoverflowusersTests
//
//  Created by Afonso Coelho on 27/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import XCTest
@testable import stackoverflowusers

final class UserListViewModelTests: XCTestCase {

    func test_viewModel_loads_data_when_view_loaded() {

    // Given
    let numberOfUsersToRequest = 20
    let vm = UserListViewModel(userListService: MockUserListService(),
                               userCellService: MockImageFetchingService(),
                               numberOfUsersToRequest: numberOfUsersToRequest,
                               userPreferencesStore: MockUserPreferenceStore())
    // When
        vm.viewStateUpdated(.didLoad)

    // Then
        XCTAssertEqual(vm.userDataSource?.count, numberOfUsersToRequest)
    }

    func test_status_changed_handler_called() {

        // Given
        let vm = UserListViewModel(userListService: MockUserListService(),
                                   userCellService: MockImageFetchingService(),
                                   numberOfUsersToRequest: 20,
                                   userPreferencesStore: MockUserPreferenceStore())

        // When
        let exp = expectation(description: "viewmodel state changed handler called")
        exp.expectedFulfillmentCount = 1 // load & albums
        vm.statusChangedHandler = { exp.fulfill() }
        vm.viewStateUpdated(.didLoad)

        // Then

        wait(for: [exp], timeout: 1.0)
        switch vm.viewModelState {
            case .loaded: break
            default:
                XCTFail("unexpected view model state")
        }

        XCTAssertEqual(vm.userDataSource?.count, 20)
    }

    func test_invalid_data_request_response_handling() {

        // Given
        let dataType = MockUserListDataType.invalidData
        let vm = UserListViewModel(userListService: MockUserListService(mockDataType: dataType),
                                   userCellService: MockImageFetchingService(),
                                   numberOfUsersToRequest: 20,
                                   userPreferencesStore: MockUserPreferenceStore())

        // When
        vm.viewStateUpdated(.didLoad)

        // Then

        //get viewModelState, can't == because of associated value on error
        switch vm.viewModelState {
            case .error:
                break
            default:
                XCTFail("unexpected ViewModelState")
        }

        XCTAssertNil(vm.userDataSource?.count)
    }

    func test_it_returns_expected_user_cell_viewmodel() {

        // Given
        let vm = UserListViewModel(userListService: MockUserListService(),
                                   userCellService: MockImageFetchingService(),
                                   numberOfUsersToRequest: 20,
                                   userPreferencesStore: MockUserPreferenceStore())

        // When

        vm.viewStateUpdated(.didLoad)
        let cellViewModel = vm.userListCellViewModel(for: 0)

        // Then

        XCTAssertEqual(cellViewModel.name, "Jon Skeet")
        XCTAssertEqual(cellViewModel.reputation, String(1159700))
        XCTAssertFalse(cellViewModel.blocked)
        XCTAssertFalse(cellViewModel.followed)
    }
}
