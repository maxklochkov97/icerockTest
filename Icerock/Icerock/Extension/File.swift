//
//  File.swift
//  Icerock
//
//  Created by Максим Клочков on 20.05.2022.
//

import Foundation

protocol UserDefaultsDelegate: AnyObject {
    var userDefaults: UserDefaults { get set }
}
