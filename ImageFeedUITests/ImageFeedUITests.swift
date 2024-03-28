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
        sleep(2)
        loginTextField.typeText("timurkaev_malik@icloud.com")
        sleep(2)
        doneButton.tap()
        
        sleep(2)
        passwordTextField.tap()
        passwordTextField.typeText("Marktsar_2002")
        sleep(3)
        doneButton.tap()
        
        sleep(1)
        webView.buttons["Login"].tap()
        
        let tableQuery = app.tables
        let cell = tableQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        cell.swipeUp()
        sleep(3)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 2)
        let button = cellToLike.buttons["LikeButton"]
        
        
        button.tap()
        sleep(1)
        button.tap()
        sleep(3)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navigationButon = app.buttons["navBackButton"]
        navigationButon.tap()
        sleep(2)
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        sleep(2)
        XCTAssertTrue(app.staticTexts["Malik Timurkaev"].exists)
        XCTAssertTrue(app.staticTexts["@malik_timurkaev"].exists)
        
        sleep(1)
        app.buttons["LogoutRedButton"].tap()
        sleep(1)
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        
        sleep(2)
        
        XCTAssertTrue(app.buttons["Authenticate"].exists)
        XCTAssertTrue(app.images["auth_logo"].exists)
    }
}
