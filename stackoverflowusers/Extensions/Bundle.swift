//
//  Bundle.swift
//  stackoverflowusers
//
//  Created by Afonso Coelho on 27/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import Foundation

extension Bundle {
    func contents(of resource: String, ofType: String) -> Data? {
        guard
            let resourcePath = path(forResource: resource, ofType: ofType)
            else {
                return nil
        }

        do {
            return try Data(contentsOf: URL(fileURLWithPath: resourcePath))
        } catch {
            assertionFailure("failed to read contents of resource file \(resourcePath) - \(error)")
            return nil
        }
    }
}
