//
//  Constants.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 07.02.2024.
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

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            authURLString: Constants.unsplashAuthorizeURLString,
            defaultBaseURL: Constants.defaultBaseURL)
    }
}




//let AccessKey = "L3dOSaGdgL9TefBpwyAFw6NivynNwyzLyxOjeeXkZuI"
//let SecretKey = "Hom8IRJh78jljj3RcIYQ0VBs-TxXNACF5ZJrYy7yjD0"
//let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
//var AccessScope = "public+read_user+write_likes"
//
//var defaultBaseURL: URL {
//    guard let url = URL(string: "https://api.unsplash.com/") else {
//        preconditionFailure("error while implementing defaultBaseURL")
//    }
//    return url
//}

