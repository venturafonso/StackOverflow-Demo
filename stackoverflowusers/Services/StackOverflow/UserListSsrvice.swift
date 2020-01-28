//
//  UserListSsrvice.swift
//  stackoverflowusers
//
//  Created by Afonso Coelho on 26/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import Foundation

protocol UserListAPI { // Make the network API used on the viewModel as "dumb" as possible, so it stays clear what requests the viewModel does and can do.
    func fetchTopReputationUsers(amount: Int, completion: @escaping (Result<[User], RequestError>) -> Void)
    func fetchLowestReputationUsers(amount: Int, completion: @escaping (Result<[User], RequestError>) -> Void)
}

final class UserListService: Service {
    enum orderingType: String {
        case desc
        case asc
    }

    enum sortingType: String {
        case reputation
        case creation
        case name
        case modified
    }

    public enum siteType: String {
        case stackoverflow
    }

    private(set) var networking: NetworkingProtocol
    private let configuration: UserListServiceConfiguration

    init(networking: NetworkingProtocol, configuration: UserListServiceConfiguration) {
        self.networking = networking
        self.configuration = configuration
    }

    private func buildQueryParameters(pageSize: Int,
                                      resultOrder: orderingType = .desc,
                                      resultSortBy: sortingType = .reputation,
                                      site: siteType = .stackoverflow) -> [URLQueryItem] { //Create any type of query parameter combination needed, with type safety,
        //default values could be configured or not exist at all
        var urlQueryItems = [URLQueryItem]()
        urlQueryItems.append(URLQueryItem(name: UserServiceConstants.queryParameterKeys.pageSize,
                                          value: String(pageSize)))
        urlQueryItems.append(URLQueryItem(name: UserServiceConstants.queryParameterKeys.order,
                                          value: resultOrder.rawValue))
        urlQueryItems.append(URLQueryItem(name: UserServiceConstants.queryParameterKeys.sort,
                                          value: resultSortBy.rawValue))
        urlQueryItems.append(URLQueryItem(name: UserServiceConstants.queryParameterKeys.site,
                                          value: site.rawValue))
        return urlQueryItems
    }

    private func fetchUsers(with parameters: [URLQueryItem]? = nil,
                            completion: @escaping (Result<[User], RequestError>) -> Void) {
        networking.executeRequest(with: configuration.baseURL,
                                  queryParameters: parameters,
                                  method: configuration.httpMethod,
                                  completion: { result in
                                    switch result {
                                        case .success(let data):
                                            do {
                                                let userList = try data.decoded() as UserList
                                                completion(.success(userList.users))
                                            } catch {
                                                completion(.failure(RequestError.decodingError(error)))
                                        }

                                        case .failure(let error):
                                            completion(.failure(error))
                                    }
        })
    }
}

// MARK: - Public API

extension UserListService: UserListAPI {
    func fetchLowestReputationUsers(amount: Int, completion: @escaping (Result<[User], RequestError>) -> Void) {
        let parameters = buildQueryParameters(pageSize: 20, resultOrder: .desc)
        fetchUsers(with: parameters, completion: completion)
    }

    func fetchTopReputationUsers(amount: Int, completion: @escaping (Result<[User], RequestError>) -> Void) {
        let parameters = buildQueryParameters(pageSize: 20)
        fetchUsers(with: parameters, completion: completion)
    }
}

// MARK: - Service configuration
struct UserListServiceConfiguration: ServiceConfigurationProtocol {
    var baseURL: URL
    var httpMethod: HTTPMethod
    var scheme: HTTPScheme
    var host: String
    var apiVersion: String
    var method: String

    init?(scheme: HTTPScheme,
          httpMethod: HTTPMethod,
          host: String,
          apiVersion: String,
          method: ServiceMethod) {
        self.httpMethod = httpMethod
        self.scheme = scheme
        self.host = host
        self.apiVersion = apiVersion
        self.method = method.rawValue

        var urlComponents = URLComponents()
        urlComponents.scheme = scheme.rawValue
        urlComponents.host = host
        urlComponents.path =  "/\(apiVersion)/\(method)"

        guard let urlFromComponents = urlComponents.url else {
            assertionFailure("Failed to initialize valid URL for \(urlComponents)")
            return nil
        }
        baseURL = urlFromComponents
    }
}
