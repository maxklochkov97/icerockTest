//
//  API.swift
//  Icerock
//
//  Created by Максим Клочков on 16.05.2022.
//

import Alamofire

enum NetworkServiceError: Error {
    case noData
    case noInternet
    case isEmpty
    case invalidToken
}

class NetworkManager {
    // maxklochkov97 : $ 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
    // https://api.github.com/users/maxklochkov97/repos

    static var userDefaults = UserDefaults()
    static var networkServiceError: NetworkServiceError?

    static func getRepositories(token: String, completion: @escaping (Result<[Repo], Error>) -> Void) {

        let headers: HTTPHeaders? = ["Authorization": "Token \(token)"]
        let mainURL = "https://api.github.com/user/repos"

        AF.request(mainURL, method: .get, headers: headers).validate().response { responseData in

            guard let data = responseData.data else {
                self.networkServiceError = .noData
                return
            }

            do {
                let repo = try JSONDecoder().decode([Repo].self, from: data)
                if repo.count == 0 {
                    self.networkServiceError = .isEmpty
                }
                completion(.success(repo))
            } catch {
                self.networkServiceError = .noData
                completion(.failure(error))
            }
        }
    }

     func getRepository(repoId: String, completion: @escaping (RepoDetails?, Error?) -> Void) {
         
     }

     func getRepositoryReadme(ownerName: String, repositoryName: String, branchName: String, completion: @escaping (String?, Error?) -> Void) {
        // TODO:
     }

     func signIn(token: String, completion: @escaping (UserInfo?, Error?) -> Void) {
        // TODO:
     }


  }

