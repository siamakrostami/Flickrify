//
//  FlickrCollectionViewCell.swift
//  Flickrify
//
//  Created by Siamak Rostami on 6/30/22.
//

import UIKit
import SDWebImage

class FlickrCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FlickrCollectionViewCell"
    @IBOutlet weak var flickrImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.flickrImageView.sd_cancelCurrentImageLoad()
        self.flickrImageView.image = nil
    }
    
    func configureCell(imageUrl : URL?) {
        if let cached = SDImageCache.shared.imageFromDiskCache(forKey: imageUrl?.absoluteString){
            DispatchQueue.main.async {
                debugPrint("fetched offline")
                self.flickrImageView.image = cached
            }
        }else{
            //Load Image from remote URL and cache it on disk
            DispatchQueue.main.async {
                self.flickrImageView.sd_setImage(with: imageUrl)
            }
        }
    }
    
}
