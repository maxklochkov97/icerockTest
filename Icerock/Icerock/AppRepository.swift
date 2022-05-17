//
//  API.swift
//  Icerock
//
//  Created by Максим Клочков on 16.05.2022.
//

import Alamofire

class AppRepository {

    // maxklochkov97 : $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

    let array = [String]()
    var mainURL = "https://api.github.com/users/"
    let userName = "maxklochkov97/repos"
    let token = "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"

    func getPublicRepositories(forName name: String, completion: @escaping (Array<Repo>?, Error?) -> Void) {
        AF.request(self.mainURL + name).response { responseData in
            guard let data = responseData.data else { return }
            do {
                let repo = try JSONDecoder().decode([Repo].self, from: data)
                completion(repo, nil)
                print(repo)
            } catch {
                print("localizedDescription Error decoding == \(error.localizedDescription)")
                print("Error decoding == \(error)")
                completion([], nil)
            }
        }
    }

     func getRepositories(completion: @escaping (Array<Repo>?, Error?) -> Void) {
         // TODO:
     }

     func getRepository(repoId: String, completion: @escaping (RepoDetails?, Error?) -> Void) {
        // TODO:
     }

     func getRepositoryReadme(ownerName: String, repositoryName: String, branchName: String, completion: @escaping (String?, Error?) -> Void) {
        // TODO:
     }

     func signIn(token: String, completion: @escaping (UserInfo?, Error?) -> Void) {
        // TODO:
     }

     // TODO:
  }

