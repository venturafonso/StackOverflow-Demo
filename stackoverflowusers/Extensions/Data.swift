//
//  Data.swift
//  stackoverflowusers
//
//  Created by Afonso Coelho on 26/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import Foundation

//Thanks to John Sundell
//https://github.com/JohnSundell/Codextended
public extension Data {
    /// Decode this data into a value, optionally using a specific decoder.
    /// If no explicit encoder is passed, then the data is decoded as JSON.
    func decoded<T: Decodable>(as type: T.Type = T.self,
                               using decoder: JSONDecoder = JSONDecoder()) throws -> T {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(T.self, from: self)
    }
}
