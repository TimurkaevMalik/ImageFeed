//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 01.03.2024.
//

import UIKit

final class ProfileImageService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

    private(set) var avatarURL: String?
    static let shared = ProfileImageService()
    private var task: URLSessionTask?
    
    private init(){}
    
    private enum PrProfileImageServiceError: Error {
        case codeError
        case responseError
        case invalidRequest
    }
    
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String,Error>) -> Void){
        
        assert(Thread.isMainThread)

        if task != nil {
            task?.cancel()
        }
        
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
                    completion(.failure(PrProfileImageServiceError.responseError))
                }
                
                if let data = data {
                    do {
                        let profileImageURL = try? JSONDecoder().decode(UserResult.self, from: data)
                        
                        guard let profileImageURL = profileImageURL else {return}
                        
                        self.avatarURL = profileImageURL.profileImage.small
                        
                        completion(.success((profileImageURL.profileImage.small)))
                        
                        NotificationCenter.default.post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": profileImageURL.profileImage])
                    }
                }
                self.task = nil
            }
        }
        
        task = session
        session.resume()
    }
    
    func makeRequestBody(token: String, username: String) -> URLRequest? {
        
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            assertionFailure("Failed to create  URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(String(describing: token))", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
