//
//  Model.swift
//  Icerock
//
//  Created by Максим Клочков on 16.05.2022.
//

import Foundation
import UIKit

struct Repo: Decodable  {
    var name: String?
    var language: String?
    var description: String?

    var id: Int
    var htmlUrl: String
    var license: [String: String]?
    var forks: Int?
    var watchers: Int?
    var stars: Int?

    var fullName: String?
    var defaultBranch: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case language = "language"
        case description = "description"

        case id = "id"
        case htmlUrl = "html_url"
        case watchers = "watchers_count"
        case forks = "forks_count"
        case stars = "stargazers_count"
        case license = "license"

        case fullName = "full_name"
        case defaultBranch = "default_branch"
        
    }
}

struct OwnerDetails {

}

struct Repo2: Decodable {
    var name: String?
    var language: String?
    var description: String?
    var id: Int
}

struct RepoDetails: Decodable  {
    var name: String?
    var id: Int
    var htmlUrl: String
    var license: [String: String]?
    var forks: Int?
    var watchers: Int?
    var stars: Int?
    var fullName: String?
    var defaultBranch: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
        case htmlUrl = "html_url"
        case watchers = "watchers_count"
        case forks = "forks_count"
        case stars = "stargazers_count"
        case license = "license"
        case fullName = "full_name"
        case defaultBranch = "default_branch"
    }
}

struct UserInfo: Decodable {
    var token: String?
    var userName: String?
}

