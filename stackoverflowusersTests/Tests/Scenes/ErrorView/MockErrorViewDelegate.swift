//
//  MockErrorViewDelegate.swift
//  stackoverflowusersTests
//
//  Created by Afonso Coelho on 28/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import XCTest
@testable import stackoverflowusers

final class MockErrorViewDelegate {
    var retryCalled: Bool = false
}

extension MockErrorViewDelegate: ErrorViewModelDelegate {
    func retry() {
        retryCalled = true
    }
}
