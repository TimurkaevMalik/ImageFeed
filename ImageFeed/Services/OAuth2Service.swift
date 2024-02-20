//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 19.02.2024.
//

import Foundation

class OAuth2Service {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let oauth2ServiceStorage = OAuth2TokenStorage()
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "client_secret", value: SecretKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents?.url else {return}
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        
        let session: URLSessionDataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let respose = response as? HTTPURLResponse, respose.statusCode < 200 || respose.statusCode >= 300 {
                completion(.failure(NetworkError.codeError))
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    
                    oauth2ServiceStorage.save(token: decodedData.accessToken)
                    completion(.success(decodedData.accessToken))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        session.resume()
    }
}
