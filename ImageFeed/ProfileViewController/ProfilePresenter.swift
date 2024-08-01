//
//  ProfileVeiwController.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 26.03.2024.
//

import Foundation
import UIKit

final class ProfilePresenter: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    private let alertPresenter = AlertPresenter()
    private let profileLogoutService = ProfileLogoutService.shared
    private let profileImageService = ProfileImageService.shared
    
    
    func avatarURL() -> URL? {
        guard let profileImageURL = profileImageService.avatarURL,
              let url = URL(string: profileImageURL)
        else { return nil }
        
        return url
    }
    
    func logoutAlert(vc: UIViewController){
        let message = "Уверены что хотите выйти?"
        let title = "Пока, пока!"
        let buttonText = "Да"
        let cancelButtonText = "Нет"
        
        alertPresenter.showAlert(vc: vc , result: AlertModel(
            message: message,
            title: title,
            buttonText: buttonText,
            cancelButtonText: cancelButtonText,
            completion: {
                self.profileLogoutService.logOut()
                self.view?.switchToSplashController()
            }
        ))
    }
}
