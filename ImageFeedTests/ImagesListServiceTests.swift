//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Malik Timurkaev on 12.03.2024.
//

import XCTest
@testable import ImageFeed

final class ImagesListServiceTests: XCTestCase {
    
    private let oauth2TokenStorage = OAuth2TokenStorage()

    func testFectchPhotos() {
        let service = ImagesListService()
        
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                expectation.fulfill()
            }
        
        service.fetchPhotosNextPage(token: oauth2TokenStorage.token!) { _ in
            
        }
        
        wait(for: [expectation],timeout: 10)
        
        XCTAssertEqual(service.photos.count, 10)
    }
    
    func testExample() {
        
    }
}
