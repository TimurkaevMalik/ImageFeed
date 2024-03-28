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
    
    func testNumberOfRows(){
        let presenter = ImageListPresenterTest()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        
        viewController.configure(presenter)
        _ = viewController.view
        
        XCTAssertEqual(viewController.tableView.numberOfRows(inSection: 0), 2)
    }
}

class ImageListPresenterTest: ImageListPresenterProtocol {
    
    let imagesListService = ImagesListService.shared
    private let dateFormatter = DateFormatManager.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    var photos: [ImageFeed.Photo] = [
        Photo(photoResult: PhotoResult(
            id: "D1jr0Mevs-c",
            width: 5280,
            height: 2970,
            createdAt: "2024-02-07T22:34:15Z",
            welcomeDescription: "The Islands of NEOM are home to kaleidoscopic-coloured coral reefs and an abundance of diverse marine life | Islands of NEOM – NEOM, Saudi Arabia",
            urls: UrlsResult(
                thumb: "https://images.unsplash.com/photo-1707343843982-f8275f3994c5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1NjQ0NDd8MXwxfGFsbHwxfHx8fHx8Mnx8MTcxMTQ3MTc1NXw&ixlib=rb-4.0.3&q=80&w=200",
                full: "https://images.unsplash.com/photo-1707343843982-f8275f3994c5?crop=entropy&cs=srgb&fm=jpg&ixid=M3w1NjQ0NDd8MXwxfGFsbHwxfHx8fHx8Mnx8MTcxMTQ3MTc1NXw&ixlib=rb-4.0.3&q=85"),
           isLiked: true)),
        
        Photo(photoResult: PhotoResult(
            id: "bXiDmZODsTw",
            width: 3842,
            height: 2619,
            createdAt: "2024-03-20T23:05:39Z",
            welcomeDescription: "Title: The great blue spring of the Lower Geyser Basin, Yellowstone Artist: Moran, Thomas, 1837-1926 Publisher: L. Prang & Co. Name on Item: TM Date: (c) 1875 https://www.digitalcommonwealth.org/search/commonwealth:5m60qs461",
            urls: UrlsResult(
                thumb: "https://images.unsplash.com/photo-1710975090671-9cb58989180d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w1NjQ0NDd8MHwxfGFsbHwyfHx8fHx8Mnx8MTcxMTQ3MTc1NXw&ixlib=rb-4.0.3&q=80&w=200",
                full: "https://images.unsplash.com/photo-1710975090671-9cb58989180d?crop=entropy&cs=srgb&fm=jpg&ixid=M3w1NjQ0NDd8MHwxfGFsbHwyfHx8fHx8Mnx8MTcxMTQ3MTc1NXw&ixlib=rb-4.0.3&q=85"),
            isLiked: false))
    ]
    
    var didCallMakeCell = false
    var didCallShouldUpdate = false
    var didCallChangeLikeRequest = false
    
    func makeCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        didCallMakeCell = true
    }
    
    func changeLikeRequest(indexPath: IndexPath, cell: ImageFeed.ImagesListCell) {
    }
    
    func configCellHeight(tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    func shouldUpdate(tableView: UITableView?) {
        didCallShouldUpdate = true
    }
    
    func fetchImages() {
    }
}
