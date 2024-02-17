//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 09.02.2024.
//

import UIKit

class AuthViewController: UIViewController {
   
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
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
    }
    
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
