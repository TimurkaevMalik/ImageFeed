//
//  SinglePhotoDecoder.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 15.03.2024.
//

import Foundation

struct SinglePhotoDecoder: Codable {
    let photo: PhotoData
}

struct PhotoData: Codable {
    let isLiked: Bool
    
    private enum CodingKeys: String, CodingKey{
        case isLiked = "liked_by_user"
    }
}
