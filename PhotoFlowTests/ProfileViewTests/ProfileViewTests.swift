//
//  ProfileViewTests.swift
//  PhotoFlowTests
//
//  Created by Malik Timurkaev on 26.03.2024.
//

@testable import PhotoFlow
import XCTest

final class ProfileViewTests: XCTestCase {
    
    func testDidCallLogoutMethod(){
        let presenter = ProfilePresenterSpy()
        let viewController = ProfileViewController()
        
        viewController.presenter = presenter
        viewController.didTapLogoutButton()
        
        XCTAssertTrue(presenter.logoutAlertWasCalled)
    }
    
    func testDidCallAvatarURL(){
        let presenter = ProfilePresenterSpy()
        let viewController = ProfileViewController()
        
        viewController.presenter = presenter
        viewController.updateAvatar()
        
        XCTAssertTrue(presenter.avatarURLMethodCalled)
    }
    
    func testUpdateProfileDetails(){
        let viewController = ProfileViewController()
        
        let profile = Profile(ProfileResult(userName: "UserName", firstName: "FirstName", lastName: "LastName", bio: nil))
        
        viewController.updateProfileDetails(profile: profile)
        
        XCTAssertEqual(viewController.nameLabel.text, profile.name)
        XCTAssertEqual(viewController.loginNameLabel.text, "@\(profile.userName)")
        XCTAssertEqual(viewController.descriptionLabel.text, profile.bio)
    }
}
