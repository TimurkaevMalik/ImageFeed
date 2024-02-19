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
    
    weak var delegate: AuthViewControllerDelegate?
    
    let SegueIdentifier = "ShowWebView"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueIdentifier {
        guard
            let webViewViewController = segue.destination as? WebViewViewController else { fatalError("Failed to prepare for \(SegueIdentifier)")}
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String){
        
        let storage = OAuth2TokenStorage()
        let networkClient = OAuth2Service()
        
        func loadData() {
            networkClient.fetchOAuthToken(code: code) { result in
                
                switch result{
                case .success(let accessToken):
                    storage.save(token: accessToken)
                    
                case .failure:
                    print("Failure while loading data")
                }
            }
        }
        
        loadData()
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
