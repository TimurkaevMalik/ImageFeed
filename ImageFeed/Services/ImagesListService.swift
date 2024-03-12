//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 12.03.2024.
//

import Foundation

final class ImagesListService {
    
    private(set) var photos: [Photo] = []
    private let oauth2TokenStorage = OAuth2TokenStorage()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    private enum ImagesListServiceError: Error {
        case codeError
        case responseError
        case invalidRequest
    }
    
    func fetchPhotosNextPage(token: String, comletion: @escaping (Result<[Photo],Error>) -> Void) {
        
        guard task == nil else {
            comletion(.failure(ImagesListServiceError.invalidRequest))
            return}
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard let request = makeRequstBody(pageNumber: nextPage, token: token) else {
            comletion(.failure(ImagesListServiceError.codeError))
            return}
        
        let session = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            DispatchQueue.main.async {
                
                guard let self = self else {return}
                
                if let error = error {
                    comletion(.failure(error))
                    return
                }
                
                if let response = response as? HTTPURLResponse,
                   response.statusCode < 200 || response.statusCode >= 300 {
                    print(response.statusCode)
                    print(response)
                    comletion(.failure(ImagesListServiceError.responseError))
                    return
                }
                
                if let data = data {
                    do {
                        
                        let decodedData = try JSONDecoder().decode([PhotoResult].self, from: data)
                        
                        
                        for photo in decodedData {
                            self.photos.append(Photo(photoResult: photo))
                        }
                        
                        NotificationCenter.default.post(
                            name: ImagesListService.didChangeNotification,
                            object: self,
                            userInfo: ["photos": decodedData])
                        
                        comletion(.success(self.photos))
                    } catch {
                        comletion(.failure(ImagesListServiceError.codeError))
                    }
                }
                self.task = nil
            }
        }
        task = session
        session.resume()
    }
    
    private func makeRequstBody(pageNumber: Int, token: String) -> URLRequest? {
        var urlComponents = URLComponents(string: "https://api.unsplash.com/photos")
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: "\(pageNumber)"),
            URLQueryItem(name: "per_page", value: "10"),
            URLQueryItem(name: "order_by", value: "latest")
        ]
        
        guard let url = urlComponents?.url else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token))", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
