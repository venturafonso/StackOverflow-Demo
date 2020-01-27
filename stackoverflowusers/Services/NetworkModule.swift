//
//  Networking.swift
//  stackoverflowusers
//
//  Created by Afonso Coelho on 25/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
}

enum HTTPScheme: String {
    case http
    case https
}

enum RequestError: Error {
    case genericError
    case offline
    case serviceError(Error)
    case decodingError(Error)
}

struct NetworkConfiguration {
    let cachePolicy: URLRequest.CachePolicy
}

protocol Service {
    var networking: NetworkingProtocol { get }
}

protocol ServiceConfigurationProtocol { // Every service configuration needs to define these, at the very least.
    var baseURL: URL { get }
    var httpMethod: HTTPMethod { get }
    var scheme: HTTPScheme { get }
    var host: String { get }
}

protocol NetworkingProtocol {
    func executeRequest(with baseURL: URL,
                        queryParameters: [URLQueryItem]?,
                        method: HTTPMethod,
                        completion: @escaping (Result<Data, RequestError>) -> Void)
}

final class NetworkModule: NetworkingProtocol { // A common class that executes and creates the requests applying configurations to each request (e.g cache policy)
    var networkConfiguration: NetworkConfiguration
    internal let session: URLSession

    init(session: URLSession, networkConfiguration: NetworkConfiguration) {
        self.session = session
        self.networkConfiguration = networkConfiguration
    }

    func executeRequest(with baseURL: URL,
                        queryParameters: [URLQueryItem]?,
                        method: HTTPMethod,
                        completion: @escaping (Result<Data, RequestError>) -> Void) {

        let request = createRequest(from: baseURL, queryParameters: queryParameters, method: method)
        session.dataTask(with: request ?? URLRequest(url: baseURL), // build the request with the baseURL if we fail to build it from components, to avoid crashing
                         completionHandler: { data, _, error in
            if let error = error {
                completion(.failure(.serviceError(error)))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(.genericError))
            }
        }).resume()
    }

    private func createRequest(from baseURL: URL, queryParameters: [URLQueryItem]?, method: HTTPMethod) -> URLRequest? {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = queryParameters

        guard let urlFromComponents = urlComponents?.url else {
            assertionFailure("Failed to get valid URL from urlComponents \(String(describing: urlComponents?.description))")
            return nil
        }
        var request = URLRequest(url: urlFromComponents)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.cachePolicy = networkConfiguration.cachePolicy
        request.httpMethod = method.rawValue

        return request
    }
}
