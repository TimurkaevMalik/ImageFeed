//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 23.01.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    var presenter: ProfilePresenterProtocol?
    
    lazy var avatarImageView = UIImageView()
    lazy var nameLabel = UILabel()
    lazy var loginNameLabel = UILabel()
    lazy var descriptionLabel = UILabel()
    lazy var logoutButton = UIButton()
    
    private var profileImageServeceObserver: NSObjectProtocol?
    private let profileImageService = ProfileImageService.shared

    private let profileService = ProfileService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let alertPresenter = AlertPresenter()
    
    
    private func createProfileScreenWithViews() {
        
        view.backgroundColor = UIColor(named: "YPBlack")
        
        logoutButton = UIButton.systemButton(with: UIImage(named: "logout_button")!, target: self, action: #selector(didTapLogoutButton))
        
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 35
        
        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        } else {
            print("variable profileService.profile is empty")
        }
        
        if profileImageService.avatarURL != nil {
            updateAvatar()
        } else {
            print("variable profileImageService.avatarURL is empty")
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
        
        nameLabel.text = profile.name
        loginNameLabel.text = "@\(profile.userName)"
        descriptionLabel.text = profile.bio
    }
    
    func updateAvatar() {
        guard let url = presenter?.avatarURL() else {return}
        
        let processor = RoundCornerImageProcessor(cornerRadius: 450)
        
        avatarImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: [.processor(processor)])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ProfilePresenter()
        presenter?.view = self
        
        profileImageServeceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                
                self?.updateAvatar()
            })
        
        createProfileScreenWithViews()
    }
    
    @objc func didTapLogoutButton() {
        presenter?.logoutAlert()
    }    
}