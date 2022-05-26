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
    case invalidToken
}

class NetworkManager {    
    static func signIn(token: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let mainURL = "https://api.github.com/user/repos"
        let headers: HTTPHeaders? = ["Authorization": "Token \(token)"]
        
        AF.request(mainURL, method: .get, headers: headers).validate().response { responseData in
            
            guard let data = responseData.data else {
                completion(.failure(NetworkServiceError.noData))
                return
            }
            
            do {
                _ = try JSONDecoder().decode([Repo].self, from: data)
                completion(.success(token))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    static func getRepositories(completion: @escaping (Result<[Repo], Error>) -> Void) {
        
        guard Network.reachability.isReachable else {
            completion(.failure(NetworkServiceError.noInternet))
            return
        }
        
        guard let token = KeyValueStorage.userDefaults.value(forKey: "token") as? String else {
            completion(.failure(NetworkServiceError.invalidToken))
            return
        }
        
        let mainURL = "https://api.github.com/user/repos"
        let headers: HTTPHeaders? = ["Authorization": "Token \(token)"]
        
        AF.request(mainURL, method: .get, headers: headers).validate().response { responseData in
            
            guard let data = responseData.data else {
                completion(.failure(NetworkServiceError.noData))
                return
            }
            
            do {
                let repo = try JSONDecoder().decode([Repo].self, from: data)
                completion(.success(repo))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    static func getRepository(repoId: Int, completion: @escaping (Result<RepoDetails, Error>) -> Void) {
        
        guard Network.reachability.isReachable else {
            completion(.failure(NetworkServiceError.noInternet))
            return
        }
        
        guard let token = KeyValueStorage.userDefaults.value(forKey: "token") as? String else {
            completion(.failure(NetworkServiceError.invalidToken))
            return
        }
        
        let mainURL = "https://api.github.com/user/repos"
        let headers: HTTPHeaders? = ["Authorization": "Token \(token)"]
        
        AF.request(mainURL, method: .get, headers: headers).validate().response { responseData in
            
            guard let data = responseData.data else {
                completion(.failure(NetworkServiceError.noData))
                return
            }
            
            do {
                let repos = try JSONDecoder().decode([RepoDetails].self, from: data)
                
                var currentRepo: RepoDetails!
                for repo in repos {
                    if repo.id == Int(repoId) {
                        currentRepo = repo
                    }
                }
                
                completion(.success(currentRepo))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    static func getRepositoryReadme(fullRepoName: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard Network.reachability.isReachable else {
            completion(.failure(NetworkServiceError.noInternet))
            return
        }
        
        guard let token = KeyValueStorage.userDefaults.value(forKey: "token") as? String else {
            completion(.failure(NetworkServiceError.invalidToken))
            return
        }
        
        let mainURL = "https://api.github.com/repos/\(fullRepoName)/contents/README.md"
        let headers: HTTPHeaders? = ["Authorization": "Token \(token)"]
        
        AF.request(mainURL, method: .get, headers: headers).validate().response { responseData in
            
            guard let data = responseData.data else {
                completion(.failure(NetworkServiceError.noData))
                return
            }
            
            do {
                let contentModel = try JSONDecoder().decode(ContentModel.self, from: data)
                guard let string = contentModel.content.base64Decoded() else {
                    completion(.failure(NetworkServiceError.noData))
                    return
                }
                completion(.success(string))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
