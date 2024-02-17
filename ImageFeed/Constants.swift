//
//  Constants.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 07.02.2024.
//

import Foundation


    let AccessKey = "L3dOSaGdgL9TefBpwyAFw6NivynNwyzLyxOjeeXkZuI"
    let SecretKey = "Hom8IRJh78jljj3RcIYQ0VBs-TxXNACF5ZJrYy7yjD0"
    let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
    var AccessScope = "public+read_user+write_likes"
    
    var DefaultBaseURL: URL {
        guard let url = URL(string: "https://api.unsplash.com/") else {
            preconditionFailure("error while implementing defaultBaseURL")
        }
        return url
    }

