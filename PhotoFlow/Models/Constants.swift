//
//  Constants.swift
//  PhotoFlow
//
//  Created by Malik Timurkaev on 28.03.2024.
//

import Foundation

enum Constants {
    static let accessKey = "L3dOSaGdgL9TefBpwyAFw6NivynNwyzLyxOjeeXkZuI"
    static let secretKey = "Hom8IRJh78jljj3RcIYQ0VBs-TxXNACF5ZJrYy7yjD0"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static var defaultBaseURL: URL {
        guard let url = URL(string: "https://api.unsplash.com/") else {
            preconditionFailure("error while implementing defaultBaseURL")
        }
        return url
    }
}
