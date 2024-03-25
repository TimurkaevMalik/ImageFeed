//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 26.03.2024.
//

import Foundation

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func logoutAlert()
}

protocol ProfileViewControllerProtocol: AnyObject {
    
}
