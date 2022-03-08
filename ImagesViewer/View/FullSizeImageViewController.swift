//
//  FullSizeImageViewController.swift
//  ImagesViewer
//
//  Created by Михаил on 06.03.2022.
//

import UIKit
import Kingfisher

class FullSizeImageViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var model: ImageDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
        scrollView.delegate = self
        setImage()
    }
    
    func setImage()  {
        guard let imagePath = URL(string: model?.largeImageURL ?? "") else {
            print("Invalid URL")
            return
        }
        
        imageView.kf.setImage(with: imagePath, placeholder: UIImage(named: "placeholderimage")) { [weak self] result in
            switch result {
            case .success(_):
                return
            case .failure(_):
                if let smallImagePath = URL(string: self?.model?.webformatURL ?? "") {
                    self?.imageView.kf.setImage(with: smallImagePath)
                }
            }
        }
    }
}

extension FullSizeImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imageView.image {
                let ratioWidth = imageView.frame.width / image.size.width
                let ratioHeight = imageView.frame.height / image.size.height
                
                let ratio = ratioWidth < ratioHeight ? ratioWidth : ratioHeight
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                let conditionLeft = newWidth*scrollView.zoomScale > imageView.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                let conditioTop = newHeight*scrollView.zoomScale > imageView.frame.height
                
                let top = 0.5 * (conditioTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
}
