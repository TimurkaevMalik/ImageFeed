//
//  ImageListProtocols.swift
//  PhotoFlow
//
//  Created by Malik Timurkaev on 26.03.2024.
//

import Foundation
import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

protocol ImagesListCellProtocol {
    func setIsLiked(_ isLiked: Bool)
}

protocol ImageListPresenterProtocol: AnyObject {
    var photos: [Photo] { get set }
    
    func makeCell(for cell: ImagesListCell, with indexPath: IndexPath)
    
    func changeLikeRequest(indexPath: IndexPath, cell: ImagesListCellProtocol)
    
    func configCellHeight(tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    
    func shouldUpdate(tableView: UITableView?)
    
    func fetchImages()
}

protocol ImagesListViewControllerProtocol {
    
}
