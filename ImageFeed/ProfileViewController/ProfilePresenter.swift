//
//  ProfileVeiwController.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 26.03.2024.
//

import Foundation

class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let alertPresenter = AlertPresenter()

    
    func didTapLogoutButton(){
        let message = "Уверены что хотите выйти?"
        let title = "Пока, пока!"
        let buttonText = "Да"
        let cancelButtonText = "Нет"
        
        alertPresenter.showAlert(vc: view, result: AlertModel(
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
