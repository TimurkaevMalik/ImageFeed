//
//  ProfileLogoutService.swift
//  PhotoFlow
//
//  Created by Malik Timurkaev on 15.03.2024.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileImageService = ProfileImageService.shared
    private let profileService = ProfileService.shared
    private let imagesListService = ImagesListService.shared
    
    private init() {}
    
    func logOut(){
        cleanStrorage()
        cleanCookies()
    }
    
    private func cleanCookies(){
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) {}
            }
        }
    }
    
    private func cleanStrorage(){
        oauth2TokenStorage.removeToken()
        profileImageService.removeAvatarURL()
        imagesListService.removePhotos()
        profileService.removeProfileInfo()
    }
}
