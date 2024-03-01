//
//  UserResult.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 01.03.2024.
//

import UIKit

struct UserResult: Codable {
    var profileImage: [String:String]
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct Image: Codable {
    var small: String
}
