//
//  ViewController.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 05.01.2024.
//

import UIKit
import Kingfisher

class ImagesListViewController: UIViewController {
    
    
    private var imagesListServiceObserver: NSObjectProtocol?
    
    let imagesListService = ImagesListService()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    @IBOutlet private var tableView: UITableView!
    
    var photos: [Photo] = []
    private var photosName: [String] = Array(0..<20).map{ "\($0)" }
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {

        cell.cellImage.kf.setImage(with: URL(string: photos[indexPath.row].thumbImageURL), placeholder: UIImage(named: "Placeholder2"))
        
        let isLiked = photos[indexPath.row].isLiked
        let likeImage = isLiked ? UIImage(named: "redLike") : UIImage(named: "emptyLike")
        cell.likeButton.setImage(likeImage, for: .normal)
        
        if let date = photos[indexPath.row].createdAt {
            cell.dateLabel.text = dateFormatter.string(from: date)
        } else {
            cell.dateLabel.text = ""
        }
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
        
        guard let token = oauth2TokenStorage.token else {
            return
        }
        
        imagesListService.fetchPhotosNextPage(token: token) { result in
            
            switch result {
            case .success(let data):
                print(data.count)
                
            case .failure(let error):
                print(error)
            }
        }
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
                print("RECIEVED")
            })
        
        fetchImages()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == ShowSingleImageSegueIdentifier {
            
            let viewController = segue.destination as? SingleImageViewController
            
            guard let indexPath = sender as? IndexPath else {return}
            
            let url = URL(string: photos[indexPath.row].largeImageURL)

//            viewController?.photo = photos[indexPath.row]
            viewController?.url = url
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
        //        guard let image = UIImage(named: photos[indexPath.row].id) else {
        //            return 0
        //        }
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
        guard let token = oauth2TokenStorage.token else {return}
        
        imagesListService.fetchPhotosNextPage(token: token) { result in
            
            switch result {
                
            case .success(_):
                print("SUCCESS")
            case .failure(_):
                print("Failure")
                break
            }
        }
    }
}
