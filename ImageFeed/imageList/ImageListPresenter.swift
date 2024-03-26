//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 26.03.2024.
//

import Foundation
import UIKit

class ImageListPresenter: ImageListPresenterProtocol{
    
    var photos: [Photo] = []
    private let dateFormatter = DateFormatManager.shared
    let imagesListService = ImagesListService.shared
    private let oauth2TokenStorage = OAuth2TokenStorage()

    
    func fetchImages() {
        guard let token = oauth2TokenStorage.token else {return}
        
        imagesListService.fetchPhotosNextPage(token: token) { _ in}
    }
    
    
    func makeCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        cell.cellImage.kf.setImage(with: URL(string: photos[indexPath.row].thumbImageURL), placeholder: UIImage(named: "Placeholder2"))
        
        let isLiked = photos[indexPath.row].isLiked
        
        let likeImage = isLiked ? UIImage(named: "redLike") : UIImage(named: "emptyLike")
        cell.likeButton.setImage(likeImage, for: .normal)
        
        cell.dateLabel.text = dateFormatter.fomateStringDate(string: photos[indexPath.row].createdAt)
    }
    
    func configCellHeight(tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let imageSize = photos[indexPath.row].size
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = imageSize.width
        
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func changeLikeRequest(indexPath: IndexPath, cell: ImagesListCell) {
        
        guard let token = oauth2TokenStorage.token else {return}
        
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked, token: token) { result in
            
            UIBlockingProgressHUD.dismiss()
            
            switch result{
                
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
                
            case .failure:
                break
            }
        }
    }
}
