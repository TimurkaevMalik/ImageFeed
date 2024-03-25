//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 22.03.2024.
//

import Foundation


final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol){
        self.authHelper = authHelper
    }

    func viewDidLoad() {
        
        guard let request = authHelper.authRequest() else {return}

        didUpdateProgressValue(0)
        view?.load(request: request)
    }

    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)

        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }

    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }

    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}















//if let urlComponents = URLComponents(string: url.absoluteString),
//   urlComponents.path == "/oauth/authorize/native",
//   let items = urlComponents.queryItems,
//   let codeItem = items.first(where: { $0.name == "code" })
//{
//    return codeItem.value
//} else {
//    return nil
//}


//        guard
//            var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize")
//        else {
//            assertionFailure("Invalid authorization URL string: \("https://unsplash.com/oauth/authorize")")
//            return
//        }
//
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: AccessKey),
//            URLQueryItem(name: "redirect_uri", value: RedirectURI),
//            URLQueryItem(name: "response_type", value: "code"),
//            URLQueryItem(name: "scope", value: AccessScope)
//        ]
//
//        guard
//            let url = urlComponents.url
//        else {
//            assertionFailure("Failed to construct authorization URLRequest with components: \(urlComponents)")
//            return
//        }
//
//        let request = URLRequest(url: url)
