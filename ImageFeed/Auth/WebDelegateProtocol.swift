//
//  WebDelegateProtocol.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 12.02.2024.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
