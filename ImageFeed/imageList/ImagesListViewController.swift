//
//  ViewController.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 05.01.2024.
//

import UIKit
import Kingfisher

class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    var presenter = ImageListPresenter()
    let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"


    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.delegete = self
        
        presenter.makeCell(for: cell, with: indexPath)
    }
    
    func updateTableViewAnimated() {
        
        let oldCount = presenter.photos.count
        let newCount = imagesListService.photos.count
        presenter.photos = imagesListService.photos
        
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
        
        presenter.fetchImages()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == ShowSingleImageSegueIdentifier {
            
            let viewController = segue.destination as? SingleImageViewController
            
            guard let indexPath = sender as? IndexPath else {return}
            
            viewController?.fullImageUrl = presenter.photos[indexPath.row].largeImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}


extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.photos.count
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
        
        return presenter.configCellHeight(tableView: tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        guard indexPath.row + 1 == imagesListService.photos.count else {
            return
        }
        presenter.fetchImages()
    }
}


extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        
        presenter.changeLikeRequest(indexPath: indexPath, cell: cell)
    }
}
