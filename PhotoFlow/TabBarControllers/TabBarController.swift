//
//  TabBarController.swift
//  PhotoFlow
//
//  Created by Malik Timurkaev on 07.03.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        
        guard let imagesListViewController = imagesListViewController as? ImagesListViewController else {
            return
        }
        
        imagesListViewController.configure(ImageListPresenter.shared)
        imagesListViewController.shouldAddObserver(true)
        
        let profileViewController = ProfileViewController()
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil)
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
