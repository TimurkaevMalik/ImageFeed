//
//  Photo.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 12.03.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
    
    init(photoResult: PhotoResult) {
        self.id = photoResult.id
        self.size = CGSize(width: photoResult.width, height: photoResult.height)
        self.welcomeDescription = photoResult.welcomeDescription
        self.thumbImageURL = photoResult.urls.thumb
        self.largeImageURL = photoResult.urls.full
        self.isLiked = photoResult.isLiked
        
        self.createdAt = {
            if let dateString = photoResult.createdAt {

                let dateFormatter = ISO8601DateFormatter()
                let date = dateFormatter.date(from: dateString)
                
                guard let date = date else {
                    return nil
                }
                
                return date
            } else {
                return nil
            }
        }()
    }
}
