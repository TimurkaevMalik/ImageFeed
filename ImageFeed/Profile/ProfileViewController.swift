//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 23.01.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private var avatarImageView = UIImageView()
    private var nameLabel = UILabel()
    private var loginNameLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var logoutButton = UIButton()
    
    
    func createProfileScreenWithViews() {
        logoutButton = UIButton.systemButton(with: UIImage(named: "logout_button")!, target: self, action: #selector(didTapLogoutButton))
        avatarImageView.image = UIImage(named: "Avatar_Image")
        
        nameLabel.text = "Екатерина Новикова"
        loginNameLabel.text = "@ekaterina_nov"
        descriptionLabel.text = "Hello, world"
        
        
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createProfileScreenWithViews()
    }
    
    
    @objc func didTapLogoutButton() {
        
        print("did tap logout button")
    }
}
