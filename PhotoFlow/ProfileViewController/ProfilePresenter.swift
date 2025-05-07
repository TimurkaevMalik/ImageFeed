//
//  ProfileVeiwController.swift
//  PhotoFlow
//
//  Created by Malik Timurkaev on 26.03.2024.
//

import Foundation
import UIKit

final class ProfilePresenter: ProfilePresenterProtocol {
    
    var view: ProfileViewControllerProtocol?
    
    private let profileLogoutService = ProfileLogoutService.shared
    private let profileImageService = ProfileImageService.shared
    
    
    func avatarURL() -> URL? {
        guard let profileImageURL = profileImageService.avatarURL,
              let url = URL(string: profileImageURL)
        else { return nil }
        
        return url
    }
    
    func logoutAlert(){
        
        view?.logoutAlert(model: AlertModel(
            message: "Уверены что хотите выйти?",
            title: "Пока, пока!",
            buttonText: "Да",
            cancelButtonText: "Нет",
            completion: {
                self.profileLogoutService.logOut()
                self.view?.switchToSplashController()
            }))
    }
}
