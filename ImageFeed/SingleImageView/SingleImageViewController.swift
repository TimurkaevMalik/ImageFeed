//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 25.01.2024.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else {return}
            imageView.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
    }
}
