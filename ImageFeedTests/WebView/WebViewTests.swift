//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Malik Timurkaev on 25.03.2024.
//

@testable import ImageFeed
import Foundation
import XCTest


final class WebViewTests: XCTestCase {
    
    
    func testViewControllerCallsViewDidLoad(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        let authHelper = AuthHelper(configuration: AuthConfiguration.standard)
        let presenter = WebViewPresenter(authHelper: authHelper)
        let webViewController = WebViewViewControllerSpy()
        
        presenter.view = webViewController
        webViewController.presenter = presenter
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(webViewController.loadMethodCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        let authHelper = AuthHelper(configuration: AuthConfiguration.standard)
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        let shoudHideProgress = presenter.shouldHideProgress(for: progress)
        
        XCTAssertFalse(shoudHideProgress)
    }
    
    func testProgressHidenWhenOne() {
        let authHelper = AuthHelper(configuration: AuthConfiguration.standard)
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
        let shoudHideProgress = presenter.shouldHideProgress(for: progress)
        
        XCTAssertTrue(shoudHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: AuthConfiguration.standard)
        
        let url = authHelper.authURL()
        let urlString = url!.absoluteString
        
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
    }
    
    func testCodeFromURL() {
        let authHelper = AuthHelper(configuration: AuthConfiguration.standard)
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents.url!
        
        let code = authHelper.code(from: url)
        
        XCTAssertEqual(code, "test code")
    }
}
