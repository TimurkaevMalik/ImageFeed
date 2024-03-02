//
//  UserResult.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 01.03.2024.
//

import UIKit

struct UserResult: Codable {
    var profileImage: Image
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct Image: Codable{
    var small: String
}

struct ImageURL {
    var theURL: String
    
    init(theURL: String) {
        self.theURL = theURL
    }
}
