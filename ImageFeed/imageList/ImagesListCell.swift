//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 17.01.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var cellImage: UIImageView!
    
    static let reuseIdentifier = "ImagesListCell"
    weak var delegete: ImagesListCellDelegate?
    
    func setIsLiked(_ isLiked: Bool) {
        print(isLiked)
        
        if isLiked == true {
            likeButton.setImage(UIImage(named: "redLike"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "emptyLike"), for: .normal)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.indicatorType = .activity
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBAction func likeButtonClicked() {
        delegete?.imageListCellDidTapLike(self)
    }
}
