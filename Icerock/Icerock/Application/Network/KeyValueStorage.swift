//
//  File.swift
//  Icerock
//
//  Created by Максим Клочков on 25.05.2022.
//

import Foundation

class KeyValueStorage {
    static var userName: String?
    static var authToken: String? {
        get {
            guard let oldToken = UserDefaults().value(forKey: "token") as? String else { return nil }
            return oldToken
        }
        set {
            UserDefaults().removeObject(forKey: "token")
            UserDefaults().setValue(newValue, forKey: "token")
        }
    }
}
