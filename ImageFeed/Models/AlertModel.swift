//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 01.03.2024.
//

import Foundation

struct AlertModel {
    var message: String
    var title: String
    var buttonText: String
    
    var completion: () -> Void
}
