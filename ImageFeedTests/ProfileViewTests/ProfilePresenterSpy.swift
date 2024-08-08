//
//  File.swift
//  ImageFeedTests
//
//  Created by Malik Timurkaev on 28.03.2024.
//

@testable import ImageFeed
import Foundation
import UIKit


final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var view: ImageFeed.ProfileViewControllerProtocol?
    
    var logoutAlertWasCalled = false
    var avatarURLMethodCalled = false
    
    func avatarURL() -> URL? {
        avatarURLMethodCalled = true
        
        return nil
    }
    
    func logoutAlert() {
        logoutAlertWasCalled = true
    }
}
