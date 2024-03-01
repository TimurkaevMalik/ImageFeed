//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 01.03.2024.
//

import UIKit

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private(set) var avatarURL: String?
    
    private init(){}
    
    private enum PrProfileImageServiceError: Error {
        case codeError
        case invalidRequest
    }
    
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String,Error>) -> Void){
        
        
        guard let request = makeRequestBody(token: token, username: username) else {
            completion(.failure(PrProfileImageServiceError.codeError))
            return
        }
        
        let session: URLSessionDataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            DispatchQueue.main.async {
                
                guard let self = self else {return}
                
                if let error = error {
                    completion(.failure(error))
                }
                
                if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode >= 300 {
                    print(response.statusCode)
                    completion(.failure(PrProfileImageServiceError.codeError))
                }
                
                if let data = data {
                    do {
                        let profileImageURL = try? JSONDecoder().decode(UserResult.self, from: data)
                        guard let imageURL = profileImageURL?.profileImage["small"] else {return}
                        print(imageURL)
                        self.avatarURL = imageURL
                    }
                }
            }
        }
        
        session.resume()
    }
    
    func makeRequestBody(token: String, username: String) -> URLRequest? {
        
        guard let url = URL(string: "https://api.unsplash.com/users/malik_timurkaev") else {
            assertionFailure("Failed to create  URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(String(describing: token))", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
