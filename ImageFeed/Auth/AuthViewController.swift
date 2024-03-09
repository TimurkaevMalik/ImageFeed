//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 09.02.2024.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

class AuthViewController: UIViewController {
    
    private var alertPresenter = AlertPresenter()
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    weak var delegate: AuthViewControllerDelegate?
    
    private let showAuthWebViewSegueIdentifier = "ShowWebView"
    
    func fetchToken(code: String){
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else {return}
            
            switch result{
            case .success:
                self.delegate?.authViewController(self, didAuthenticateWithCode: code)
                
            case .failure:
                UIBlockingProgressHUD.dismiss()
                
                self.alertPresenter.showAlert(vc: self, result: AlertModel(
                    message: "Не удалось войти в систему",
                    title: "Что-то пошло не так",
                    buttonText: "Ок", completion: {
                        print("OK TAPPED")
                    }
                ))
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == showAuthWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController else {
                return assertionFailure("Failed to prepare for \(showAuthWebViewSegueIdentifier)")}
            
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String){
        
        vc.dismiss(animated: true)
        fetchToken(code: code)
    }
    
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
