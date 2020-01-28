//
//  MockImageFetchingService.swift
//  stackoverflowusersTests
//
//  Created by Afonso Coelho on 27/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import XCTest
@testable import stackoverflowusers

final class MockImageFetchingService {
    let base64EncodedImageData = Data(base64Encoded: "iVBORw0KGgoAAAANSUhEUgAAAAUAAAABCAYAAAAW/mTzAAAAEElEQVR42mP8/5+hngENAAAvcgJ/uSPFogAAAABJRU5ErkJggg==")!
    private var returnFailure: Bool

    init(_ returnFailure: Bool = false) {
        self.returnFailure = returnFailure
    }
}

extension MockImageFetchingService: UserCellAPI {
    func fetchImageData(url: URL, completion: @escaping (Result<Data, RequestError>) -> Void) {

        returnFailure ? completion(.failure(RequestError.genericError)) : completion(.success(base64EncodedImageData))
    }
}
