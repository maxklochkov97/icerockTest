//
//  RepoModel.swift
//  Icerock
//
//  Created by Максим Клочков on 26.05.2022.
//

import Foundation

struct Repo: Decodable {
    var name: String?
    var language: String?
    var description: String?
    var id: Int
    var updatedAt: String

    enum CodingKeys: String, CodingKey {
        case name, id, language, description
        case updatedAt = "pushed_at"
    }
}
