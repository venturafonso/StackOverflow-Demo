//
//  ImageFetchingService.swift
//  stackoverflowusers
//
//  Created by Afonso Coelho on 26/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import Foundation

protocol UserCellAPI { // Make the network API used on the viewModel as "dumb" as possible, so it stays clear what requests the viewModel does and can do.
    func fetchImageData(url: URL, completion: @escaping (Result<Data, RequestError>) -> Void)
}

final class ImageFetchingService: Service {
    var networking: NetworkingProtocol

    init(networking: NetworkingProtocol) {
        self.networking = networking
    }
}

// MARK: - Public API

extension ImageFetchingService: UserCellAPI {
    func fetchImageData(url: URL, completion: @escaping (Result<Data, RequestError>) -> Void) {
        networking.executeRequest(with: url, queryParameters: nil, method: .get) { result in
            completion(result)
        }
    }
}
