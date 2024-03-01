//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 23.01.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let profileImageService = ProfileImageService.shared
    
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    
    private lazy var avatarImageView = UIImageView()
    private lazy var nameLabel = UILabel()
    private lazy var loginNameLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var logoutButton = UIButton()
    
    
    private func createProfileScreenWithViews() {
        logoutButton = UIButton.systemButton(with: UIImage(named: "logout_button")!, target: self, action: #selector(didTapLogoutButton))
        avatarImageView.image = UIImage(named: "Avatar_Image")
        

        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        } else {
            print("profileService.profile is empty")
        }
        
        nameLabel.textColor = UIColor(named: "YPWhite")
        logoutButton.tintColor = UIColor(named: "YPRed")
        loginNameLabel.textColor = UIColor(named: "YPGray")
        descriptionLabel.textColor = UIColor(named: "YPWhite")
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        view.addSubview(loginNameLabel)
        view.addSubview(nameLabel)
        view.addSubview(avatarImageView)
        view.addSubview(logoutButton)
        
        
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor)
        ])
    }
    
    func updateProfileDetails(profile: Profile) {
        
//        avatarImageView.image = 
        nameLabel.text = profile.name
        loginNameLabel.text = "@\(profile.userName)"
        descriptionLabel.text = profile.bio
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createProfileScreenWithViews()
    }
    
    
    @objc func didTapLogoutButton() {
        print("did tap logoutButton button")
        
        guard let username = profileService.profile?.userName else {
            print("username - nil")
            return
        }
        print(username)
        profileImageService.fetchProfileImageURL(token: " ", username: username) { result in
            
            switch result {
            case .success(let url):
                print(url)
            case .failure(let error):
                print("error")
            }
        }
    }
}
