//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 15.03.2024.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
