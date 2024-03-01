//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 19.02.2024.
//

import Foundation

class OAuth2Service {
    
    private enum AuthServiceError: Error {
        case codeError
        case invalidRequest
    }
    
    private var task: URLSessionTask?
    private var lastCode: String?
    private let oauth2ServiceStorage = OAuth2TokenStorage()
    
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                completion(.failure(AuthServiceError.invalidRequest))
            }
        }
        
        lastCode = code
        
        guard let request = makeAuthTokenRequest(code: code) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let session: URLSessionDataTask = URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            
            DispatchQueue.main.async {
                
                guard let self = self else {return}
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let respose = response as? HTTPURLResponse, respose.statusCode < 200 || respose.statusCode >= 300 {
                    completion(.failure(AuthServiceError.codeError))
                }
                
                if let data = data {
                    do {
                        let decodedData = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                        
                        self.oauth2ServiceStorage.save(token: decodedData.accessToken)
                        completion(.success(decodedData.accessToken))
                    } catch {
                        completion(.failure(error))
                    }
                }
                
                self.task = nil
                self.lastCode = nil
            }
        }
        
        self.task = session
        session.resume()
    }
    
    func makeAuthTokenRequest(code: String) -> URLRequest? {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "client_secret", value: SecretKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents?.url else {
            assertionFailure("Failed to create  URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
}
