//
//  ImageTableViewCell.swift
//  ImagesViewer
//
//  Created by Михаил on 05.03.2022.
//

import UIKit
import Kingfisher

class ImageCell: UITableViewCell {
    
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var colorModelLabel: UILabel!
    @IBOutlet weak var imageHeightLabel: UILabel!
    @IBOutlet weak var imageWidthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        imageV.clipsToBounds = true
        imageV.layer.cornerRadius = 20
        imageV.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func configureCell(with model: ImageDataModel) {
        guard let imagePath = URL(string: model.webformatURL) else {
            print("Invalid URL")
            return
        }
        
        imageV.kf.setImage(with: imagePath, placeholder: UIImage(named: "placeholderimage")) { [weak self] result in
            switch result {
            case .success(let value):
                if let exif = value.image.getExifData() {
                    self?.setupMetadata(exif)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupMetadata(_ exif: NSDictionary) {
        let colorModel = exif["ColorModel"] as? String
        let pixelHeight = exif["PixelHeight"] as? Int
        let pixelWidth = exif["PixelWidth"] as? Int
        colorModelLabel.text = colorModel
        imageHeightLabel.text = "\(pixelHeight ?? 0)"
        imageWidthLabel.text = "\(pixelWidth ?? 0)"
    }
}
