//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 19.02.2024.
//

import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: "access_token")
        }
        set {
            guard let newValue = newValue else {return}
            
            KeychainWrapper.standard.set(newValue, forKey: "access_token")
        }
    }
    
    func removeToken(){
        KeychainWrapper.standard.remove(forKey: "access_token")
    }
    
    func save(token: String) {
        self.token = token
    }
}
