//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Malik Timurkaev on 25.01.2024.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    var photo: Photo?
    var url: URL?
    
    var image: UIImage!
    
    
    private func addImage() {
        
        imageView.kf.setImage(with: url)
        
        guard let image = imageView.image else {
            return
        }
        
        self.image = image
        rescaleAndCenterImageInScrollView(photo: image)
    }
    
    private func zoomImage(){
        imageView.kf.setImage(with: url) {[weak self] result in
            
            DispatchQueue.main.async {
                
                guard let self = self else {return}
                
                switch result{
                    
                case .success(let result2):
                    self.image = result2.image
                    self.rescaleAndCenterImageInScrollView(photo: result2.image)
                    
                case .failure:
                    print("DIDNT SAVE IMAGE")
                }
            }
        }
        
    }
    
    private func rescaleAndCenterImageInScrollView(photo: UIImage) {
        
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = photo.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
        self.image = imageView.image
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        //        imageView.image = image
        
        zoomImage()
    }
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        
        let shareVIewController = UIActivityViewController(activityItems: [image ?? ""], applicationActivities: nil)
        
        present( shareVIewController, animated: true, completion: nil)
    }
}


extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) ->UIView? {
        imageView
    }
}
