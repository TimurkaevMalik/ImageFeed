//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 19.02.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    
    private enum CodingKeys: String, CodingKey  {
        case accessToken = "access_token"
    }
}
