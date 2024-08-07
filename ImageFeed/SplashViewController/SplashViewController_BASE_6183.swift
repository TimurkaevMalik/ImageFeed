//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 19.02.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let ShowAuthenticationScreenIdentifier = "ShowAuthenticationScreen"
    
    
    private func switchToTabBarController() {
        DispatchQueue.main.async {
            
            guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
            
            let tabBarController = UIStoryboard(name: "Main" , bundle: .main).instantiateViewController(identifier: "TabBarViewController")
            
            window.rootViewController = tabBarController
        }
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
        
        if let token = oauth2TokenStorage.token {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: ShowAuthenticationScreenIdentifier, sender: nil)
        }
    }
}


extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        
        dismiss(animated: true) { [weak self] in
            guard let self = self else {return}
            
            fetchToken(code: code)
        }
    }
    
    func fetchToken(code: String){
        DispatchQueue.main.async {
            
        self.oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
                
                guard let self = self else {return}
                
                switch result{
                case .success:
                    self.switchToTabBarController()
                case .failure:
                    break
                }
            }
        }
    }
}
