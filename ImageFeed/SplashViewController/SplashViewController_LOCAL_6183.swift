//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 19.02.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    
    private lazy var logoImage = UIImageView()
    private var alertPresenter = AlertPresenter()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    
    private func makeSplashViewControllerScreen(){
        view.backgroundColor = UIColor(named: "YPBlack")
        logoImage.image = UIImage(named: "Vector")
        
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImage)
        
        NSLayoutConstraint.activate([
            logoImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func switchToTabBarController() {
        
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    
    private func switchToAuthViewController() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            
            assertionFailure("Failed of initializing storyboard to viewCOntroller")
            return
        }
        
        viewController.delegate = self
        viewController.modalPresentationStyle = .fullScreen
        
        present(viewController, animated: true)
    }
    
    private func fetchProfileInfo(token: String) {
        profileService.fecthProfile(token) { [weak self] result in
            
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else {
                return
            }
            
            switch result{
            case .success:
                self.fetchImageURL(token: token)
                self.switchToTabBarController()
                
            case .failure:
                self.alertPresenter.showAlert(vc: self, result: AlertModel(
                    message: "Не удалось получить информацию о профиле",
                    title: "Что-то пошло не так",
                    buttonText: "Повторить запрос",
                    completion: {
                        
                        guard let token = self.oauth2TokenStorage.token else {return}
                        UIBlockingProgressHUD.show()
                        self.fetchProfileInfo(token: token)
                    }))
            }
        }
    }
    
    private func fetchImageURL(token: String){
        
        guard let username = profileService.profile?.userName else {return}
        
        profileImageService.fetchProfileImageURL(token: token, username: username) {_ in}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        makeSplashViewControllerScreen()
        
        if let token = oauth2TokenStorage.token {
            
            fetchProfileInfo(token: token)
        } else {
            switchToAuthViewController()
        }
    }
}


extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true)
    }
}
