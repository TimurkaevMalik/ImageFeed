//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Malik Timurkaev on 26.03.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    
    func testDidCallMakeCell(){
        let viewController = ImagesListViewController()
        let presenter = ImageListPresenterTest()
        let cell = ImagesListCell()
        let indexPath = IndexPath()
        viewController.configure(presenter)
        
        viewController.configCell(for: cell, with: indexPath)
        
        XCTAssertTrue(presenter.didCallMakeCell)
    }
    
    func testDidCallShouldUpdate(){
        let viewController = ImagesListViewController()
        let presenter = ImageListPresenterTest()
        
        viewController.configure(presenter)
        
        viewController.updateTableViewAnimated()
        
        XCTAssertTrue(presenter.didCallShouldUpdate)
    }
    
    func testDidCallFetchImages(){
        let presenter = ImageListPresenterTest()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        
        
        viewController.configure(presenter)
        _ = viewController.view
        
        XCTAssertTrue(presenter.didCallfetchImages)
    }
    
    func testNumberOfRows(){
        let presenter = ImageListPresenterTest()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        
        viewController.configure(presenter)
        _ = viewController.view
        
        XCTAssertEqual(viewController.tableView.numberOfRows(inSection: 0), 2)
    }
    
    
    
    func testFetchesImagesAndUpdatesPhotosArray(){
        
        let presenter = ImageListPresenter.shared
        let imagesListService = ImagesListService.shared
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                expectation.fulfill()
            }

        let oldCount = presenter.photos.count
        presenter.fetchImages()
        
        wait(for: [expectation], timeout: 10)
        presenter.shouldUpdate(tableView: viewController.tableView)
        
        sleep(3)
        let newCount = presenter.photos.count
        
        XCTAssertNotEqual(oldCount, newCount)
    }
    
    func testChangeLikeResponse(){
        //        let imagesListService = ImagesListService.shared
        let presenter = ImageListPresenter.shared
        let presenterTest = ImageListPresenterTest()
        
        let cell = ImagesListCellTest()
        let indexPath = IndexPath(row: 0, section: 0)
        
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeLikeValue,
            object: nil,
            queue: .main) { _ in
                expectation.fulfill()
            }
        
        presenter.photos = presenterTest.photos
        presenter.imagesListService.photos = presenterTest.photos
        
        XCTAssertTrue(presenter.photos[0].isLiked)
        
        presenter.changeLikeRequest(indexPath: indexPath, cell: cell)
        
        wait(for: [expectation], timeout: 10)
        
        XCTAssertFalse(presenter.photos[0].isLiked)
    }
}
