//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 23.01.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var loginNameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    @IBOutlet private var logoutButton: UIButton!
    
    @IBAction func didTapLogoutButton() {
    }
}
