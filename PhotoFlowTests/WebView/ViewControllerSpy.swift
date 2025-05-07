//
//  File.swift
//  PhotoFlowTests
//
//  Created by Malik Timurkaev on 28.03.2024.
//

@testable import PhotoFlow
import Foundation


final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var loadMethodCalled = false
    var presenter: WebViewPresenterProtocol?
    
    func load(request: URLRequest) {
        loadMethodCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {}
    
    func setProgressHidden(_ isHidden: Bool) {}
}
