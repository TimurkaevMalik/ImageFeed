//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 19.02.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    
    
    private var alertPresenter = AlertPresenter()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let ShowAuthenticationScreenIdentifier = "ShowAuthenticationScreen"
    
    
    private func switchToTabBarController() {
        
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
        let tabBarController = UIStoryboard(name: "Main" , bundle: .main).instantiateViewController(identifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == ShowAuthenticationScreenIdentifier {
            
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(ShowAuthenticationScreenIdentifier)")}
            
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        oauth2TokenStorage.token = nil
        if let token = oauth2TokenStorage.token {
            
            fetchProfileInfo(token: token)
        } else {
            performSegue(withIdentifier: ShowAuthenticationScreenIdentifier, sender: nil)
        }
    }
}


extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        
        dismiss(animated: true) { [weak self] in
            guard let self = self else {return}
            
            UIBlockingProgressHUD.show()
            fetchToken(code: code)
        }
    }
    
    func fetchToken(code: String){
        
        self.oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            
            guard let self = self else {return}
            
            switch result{
            case .success:
                guard let token = oauth2TokenStorage.token else {return}
                self.fetchProfileInfo(token: token)
                
            case .failure:
                break
            }
        }
    }
    
    func fetchProfileInfo(token: String) {
        profileService.fecthProfile(token) { [weak self] result in
            
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else {
                return
            }
            
            switch result{
            case .success:
                self.fetchImageURL(token: token)
                self.switchToTabBarController()
                
            case .failure(let error):
                self.alertPresenter.showAlert(vc: self, result: AlertModel(
                    message: "An error occurred while receiving profile information",
                    title: "\(error)",
                    buttonText: "Try again",
                    completion: {
                        
                        UIBlockingProgressHUD.show()
                        self.fetchProfileInfo(token: self.oauth2TokenStorage.token!)
                    }))
                break
            }
        }
    }
    
    func fetchImageURL(token: String){
        
        guard let username = profileService.profile?.userName else {return}
        
        profileImageService.fetchProfileImageURL(token: token, username: username) { result in
            
            switch result {
            case .success:
                break
                
            case .failure:
                print("failure while recieving imageURL")
            }
        }
    }
}
