//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 26.03.2024.
//

import Foundation
import UIKit

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func logoutAlert()
    func avatarURL() -> URL?
}

protocol ProfileViewControllerProtocol: AnyObject {
    func switchToSplashController()
    func logoutAlert(model: AlertModel)
}
