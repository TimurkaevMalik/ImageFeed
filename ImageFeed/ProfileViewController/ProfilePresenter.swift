//
//  ProfileVeiwController.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 26.03.2024.
//

import Foundation
import UIKit

class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private let alertPresenter = AlertPresenter()
    private let profileLogoutService = ProfileLogoutService.shared

    
    private func switchToSplashController() {
        
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        
        window.rootViewController = SplashViewController()
    }
    
    func logoutAlert(){
        let message = "Уверены что хотите выйти?"
        let title = "Пока, пока!"
        let buttonText = "Да"
        let cancelButtonText = "Нет"
        
        alertPresenter.showAlert(vc: (view as? UIViewController)!, result: AlertModel(
            message: message,
            title: title,
            buttonText: buttonText,
            cancelButtonText: cancelButtonText,
            completion: {
                self.profileLogoutService.logOut()
                self.switchToSplashController()
            }
        ))
    }
}
