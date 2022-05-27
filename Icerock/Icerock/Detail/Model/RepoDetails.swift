//
//  File.swift
//  Icerock
//
//  Created by Максим Клочков on 26.05.2022.
//

import Foundation

struct RepoDetails: Decodable {
    var name: String?
    var id: Int
    var htmlUrl: String
    var license: [String: String]?
    var forks: Int?
    var watchers: Int?
    var stars: Int?
    var fullName: String?
    var defaultBranch: String?
    var urlContent: String?

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
        case urlContent = "contents_url"
    }
}
