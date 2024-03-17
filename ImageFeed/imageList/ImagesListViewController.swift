//
//  ViewController.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 05.01.2024.
//

import UIKit
import Kingfisher

class ImagesListViewController: UIViewController {
    
    
    var photos: [Photo] = []
    let imagesListService = ImagesListService()
    
    @IBOutlet private var tableView: UITableView!
    
    private var imagesListServiceObserver: NSObjectProtocol?
    private let dateFormatter = RecievedDateFormatter()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private var photosName: [String] = Array(0..<20).map{ "\($0)" }
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        cell.delegete = self
        cell.cellImage.kf.setImage(with: URL(string: photos[indexPath.row].thumbImageURL), placeholder: UIImage(named: "Placeholder2"))
        
        let isLiked = photos[indexPath.row].isLiked
        
        let likeImage = isLiked ? UIImage(named: "redLike") : UIImage(named: "emptyLike")
        cell.likeButton.setImage(likeImage, for: .normal)
        
        cell.dateLabel.text = dateFormatter.fomateStringDate(string: photos[indexPath.row].createdAt)
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        if oldCount != newCount {
            tableView.performBatchUpdates {
                var indexPath: [IndexPath] = []
                
                for i in oldCount..<newCount {
                    indexPath.append(IndexPath(row: i, section: 0))
                }
                tableView.insertRows(at: indexPath, with: .automatic)
            } completion: { _ in
            }
        }
    }
    
    func fetchImages() {
        guard let token = oauth2TokenStorage.token else {return}
        
        imagesListService.fetchPhotosNextPage(token: token) { _ in}
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { _ in
                self.updateTableViewAnimated()
            })
        
        fetchImages()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == ShowSingleImageSegueIdentifier {
            
            let viewController = segue.destination as? SingleImageViewController
            
            guard let indexPath = sender as? IndexPath else {return}
            
            viewController?.fullImageUrl = photos[indexPath.row].largeImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}


extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}


extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let imageSize = photos[indexPath.row].size
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = imageSize.width
        
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        guard indexPath.row + 1 == imagesListService.photos.count else {return}
        fetchImages()
    }
}


extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else {return}
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
