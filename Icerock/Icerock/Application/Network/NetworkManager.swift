//
//  API.swift
//  Icerock
//
//  Created by Максим Клочков on 16.05.2022.
//

import Alamofire

enum NetworkServiceError: Error {
    case noInternet
    case invalidToken
    case someError
    case responseError
    case noReadme
}

class NetworkManager {    
    static func signIn(token: String, completion: @escaping (Result<String, NetworkServiceError>) -> Void) {
        
        let mainURL = "https://api.github.com/user/repos"
        let headers: HTTPHeaders? = ["Authorization": "Token \(token)"]
        
        AF.request(mainURL, method: .get, headers: headers).validate().response { responseData in
            
            guard let data = responseData.data else {
                if let error = responseData.error?.underlyingError as? URLError,
                    error.code == .notConnectedToInternet || error.code == .dataNotAllowed {
                    completion(.failure(.noInternet))
                } else {
                    completion(.failure(.someError))
                }
                return
            }
            
            do {
                _ = try JSONDecoder().decode([Repo].self, from: data)
                completion(.success(token))
            } catch {
                completion(.failure(.someError))
            }
        }
    }
    
    static func getRepositories(completion: @escaping (Result<[Repo], NetworkServiceError>) -> Void) {

        guard let token = KeyValueStorage.authToken else {
            completion(.failure(NetworkServiceError.invalidToken))
            return
        }
        
        let mainURL = "https://api.github.com/user/repos"
        let headers: HTTPHeaders? = ["Authorization": "Token \(token)"]
        
        AF.request(mainURL, method: .get, headers: headers).validate().response { responseData in
            
            guard let data = responseData.data else {
                if let error = responseData.error?.underlyingError as? URLError,
                   error.code == .notConnectedToInternet || error.code == .dataNotAllowed {
                    completion(.failure(.noInternet))
                } else {
                    completion(.failure(.someError))
                }
                return
            }

            guard responseData.error?.responseCode == nil else {
                completion(.failure(.responseError))
                return
            }

            do {
                let repo = try JSONDecoder().decode([Repo].self, from: data)
                completion(.success(repo))
            } catch {
                completion(.failure(.someError))
            }
        }
    }
    
    static func getRepository(repoId: Int, completion: @escaping (Result<RepoDetails, NetworkServiceError>) -> Void) {

        guard let token = KeyValueStorage.authToken else {
            completion(.failure(NetworkServiceError.invalidToken))
            return
        }
        
        let mainURL = "https://api.github.com/user/repos"
        let headers: HTTPHeaders? = ["Authorization": "Token \(token)"]
        
        AF.request(mainURL, method: .get, headers: headers).validate().response { responseData in
            
            guard let data = responseData.data else {
                if let error = responseData.error?.underlyingError as? URLError,
                    error.code == .notConnectedToInternet || error.code == .dataNotAllowed {
                    completion(.failure(.noInternet))
                } else {
                    completion(.failure(.someError))
                }
                return
            }

            guard responseData.error?.responseCode == nil else {
                completion(.failure(.responseError))
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
                completion(.failure(.someError))
            }
        }
    }
    
    static func getRepositoryReadme(fullRepoName: String, completion: @escaping (Result<String, NetworkServiceError>) -> Void) {

        guard let token = KeyValueStorage.authToken else {
            completion(.failure(NetworkServiceError.invalidToken))
            return
        }
        
        let mainURL = "https://api.github.com/repos/\(fullRepoName)/contents/README.md"
        let headers: HTTPHeaders? = ["Authorization": "Token \(token)"]
        
        AF.request(mainURL, method: .get, headers: headers).validate().response { responseData in

            guard let data = responseData.data else {
                if let error = responseData.error?.underlyingError as? URLError,
                    error.code == .notConnectedToInternet || error.code == .dataNotAllowed {
                    completion(.failure(.noInternet))
                } else {
                    completion(.failure(.someError))
                }
                return
            }

            guard responseData.error?.responseCode == nil else {
                if let code = responseData.error?.responseCode, code == 404 {
                    completion(.failure(.noReadme))
                } else {
                    completion(.failure(.responseError))
                }
                return
            }
            
            do {
                let contentModel = try JSONDecoder().decode(ContentModel.self, from: data)
                guard let string = contentModel.content.base64Decoded() else {
                    completion(.failure(.someError))
                    return
                }
                completion(.success(string))
            } catch {
                completion(.failure(.someError))
            }
        }
    }
}
