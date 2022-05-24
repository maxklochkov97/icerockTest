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
    static var text = ""

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

    static func getRepositoryReadme(fullRepoName: String, branchName: String, completion: @escaping (String?, Error?) -> Void) {

        // "https://raw.githubusercontent.com/maxklochkov97/maxklochkov97/main/README.md"

        guard let url = URL(string: "https://raw.githubusercontent.com/\(fullRepoName)/\(branchName)/README.md") else { return}

        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)

        if FileManager().fileExists(atPath: destinationUrl.path) {
            do {
                try FileManager().removeItem(atPath: destinationUrl.path)
            } catch {
                print("Error == \(error.localizedDescription)")
            }
        }

        if let dataFromURL = NSData(contentsOf: url) {
            if dataFromURL.write(to: destinationUrl, atomically: true) {
                print("file saved [\(destinationUrl.path)]")
                completion(destinationUrl.path, nil)
            } else {
                print("error saving file")
                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                completion(destinationUrl.path, error)
            }
        } else {
            let error = NSError(domain:"Error downloading file", code:1002, userInfo:nil)
            completion(destinationUrl.path, error)
        }
    }

    func getRepository(repoId: String, completion: @escaping (RepoDetails?, Error?) -> Void) {

    }
}

