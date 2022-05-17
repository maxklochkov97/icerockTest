//
//  Model.swift
//  Icerock
//
//  Created by Максим Клочков on 16.05.2022.
//

import Foundation

struct Repo: Decodable  {
    var name: String?
    var language: String?
    var description: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case language = "language"
        case description = "description"
    }
}

struct RepoDetails: Decodable {
    
}

struct UserInfo: Decodable {
    
}
