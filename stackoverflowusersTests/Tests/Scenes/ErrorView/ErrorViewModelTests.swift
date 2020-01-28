//
//  ErrorViewModelTests.swift
//  stackoverflowusersTests
//
//  Created by Afonso Coelho on 28/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import XCTest
@testable import stackoverflowusers

final class ErrorViewModelTests: XCTestCase {

    func test_factory_initializes_error_viewmodel_correctly_for_generic_error() {

        // Given
        let error = RequestError.genericError

        // When
        let vm = ErrorViewModel.create(for: error, delegate: MockErrorViewDelegate())

        // Then
        XCTAssertEqual(vm.title, "Whoops")
        XCTAssertEqual(vm.body, "We got an error. Please try again? :)")
        XCTAssertEqual(vm.buttonTitle, "Try again")
    }

    func test_factory_initializes_error_viewmodel_correctly_for_offline_error() {

        // Given
        let error = RequestError.offline

        //When
        let vm = ErrorViewModel.create(for: error, delegate: MockErrorViewDelegate())

        // Then        
        XCTAssertEqual(vm.title, "Hmmmmm...")
        XCTAssertEqual(vm.body, "Looks like we are offline :(")
        XCTAssertEqual(vm.buttonTitle, "Retry")
    }
}
