//
//  File.swift
//  ImageFeedTests
//
//  Created by Malik Timurkaev on 28.03.2024.
//

@testable import ImageFeed
import Foundation


final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
        
        let request = URLRequest(url: URL(string: "nil")!)
        view?.load(request: request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {}
    
    func code(from url: URL) -> String? {
        return nil
    }
}
