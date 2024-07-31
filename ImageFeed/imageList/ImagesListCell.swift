//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 17.01.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell, ImagesListCellProtocol {
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var cellImage: UIImageView!
    
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    func setIsLiked(_ isLiked: Bool) {
        
        likeButton.setImage(UIImage(named: isLiked ? "redLike" : "emptyLike"), for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.indicatorType = .activity
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBAction func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
}
