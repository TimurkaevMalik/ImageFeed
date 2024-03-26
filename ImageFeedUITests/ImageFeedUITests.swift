//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Malik Timurkaev on 26.03.2024.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }


    func testAuth() throws {
    
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        let loginTextField = webView.descendants(matching: .textField).element
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        let doneButton = app.toolbars["Toolbar"].buttons["Done"]
        
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))

        
        loginTextField.tap()
        loginTextField.typeText("timurkaev_malik@icloud.com")
        doneButton.tap()
        
        sleep(1)
        passwordTextField.tap()
        passwordTextField.typeText("Marktsar_2002")
        doneButton.tap()
        
        sleep(1)
        webView.buttons["Login"].tap()
        
        let tableQuery = app.tables
        let cell = tableQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        
    }
    
    func testProfile() throws {
        
    }
}
