//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 19.02.2024.
//

import Foundation

class OAuth2TokenStorage {
    
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: "access_token")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "access_token")
        }
    }
    
    func saveToken (token: String) {
        self.token = token
    }
}
