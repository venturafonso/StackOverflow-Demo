//
//  UserPreferencesStore.swift
//  stackoverflowusers
//
//  Created by Afonso Coelho on 27/01/2020.
//  Copyright © 2020 Afonso Coelho. All rights reserved.
//

import Foundation

class Preferences {
    var following : Bool
    var blocked: Bool

    init(following: Bool = false, blocked: Bool = false) {
        self.following = following
        self.blocked = blocked
    }
}

protocol UserPreferenceStoreProtocol {
    func toggleBlockState(for id: Int)
    func toggleFollowState(for id: Int)
    func getBlockState(for id: Int) -> Bool
    func getFollowState(for id: Int) -> Bool
}

class UserPreferenceStore: UserPreferenceStoreProtocol {
    var preferences: [Int: Preferences] = [Int: Preferences]()

    func getFollowState(for id: Int) -> Bool {
        return preferences[id]?.following ?? false
    }

    func getBlockState(for id: Int) -> Bool {
        return preferences[id]?.blocked ?? false
    }

    func toggleBlockState(for id: Int) {
        if let preferences = preferences[id] {
            preferences.blocked = true
            preferences.following = false // if we block a user, we also unfollow.
        } else {
            preferences[id] = Preferences(following: false, blocked: true)
        }
    }

    func toggleFollowState(for id: Int) {
        if let preferences = preferences[id] {
            preferences.following = !preferences.following
        } else {
            preferences[id] = Preferences(following: true)
        }
    }
}
