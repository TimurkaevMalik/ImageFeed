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
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let ShowAuthenticationScreenIdentifier = "ShowAuthenticationScreen"
    private var fetchingTask: Int?
    
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
        
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    
    private func switchToAuthViewController() {
                
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            fatalError("Failed of initializing storyboard to viewCOntroller")
        }
        
        viewController.delegate = self
        viewController.modalPresentationStyle = .fullScreen
        
        present(viewController, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        makeSplashViewControllerScreen()
        
        guard fetchingTask == nil else {return}
        
        if let token = oauth2TokenStorage.token {
            
            fetchProfileInfo(token: token)
        } else {
            switchToAuthViewController()
        }
    }
}


extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        fetchingTask = 1
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
                    message: "Не удалось войти в систему",
                    title: "Что-то пошло не так",
                    buttonText: "Ок",
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
        
        profileImageService.fetchProfileImageURL(token: token, username: username) {_ in}
    }
}
