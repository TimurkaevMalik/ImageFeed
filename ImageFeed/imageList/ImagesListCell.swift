//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 17.01.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var cellImage: UIImageView!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.indicatorType = .activity
        cellImage.kf.cancelDownloadTask()
    }
}
