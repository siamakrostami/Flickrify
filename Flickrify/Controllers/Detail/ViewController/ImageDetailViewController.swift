//
//  ImageDetailViewController.swift
//  Flickrify
//
//  Created by Siamak Rostami on 6/30/22.
//

import UIKit
import SDWebImage

class ImageDetailViewController: BaseViewController {
    
    @IBOutlet weak var flickrImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}

extension ImageDetailViewController {
    
    static func build(model : Photo , viewModel : FlickrViewModel) -> ImageDetailViewController {
        let vc = AppStoryboard.ImageDetail.viewController(viewControllerClass: ImageDetailViewController.self)
        vc.setImageAndTitle(model: model, viewModel: viewModel)
        return vc
    }
    
    private func setImageAndTitle(model : Photo , viewModel : FlickrViewModel){
        let imageUrl = viewModel.setImageUrlWithModel(model: model)
        if let cached = SDImageCache.shared.imageFromDiskCache(forKey: imageUrl?.absoluteString){
            DispatchQueue.main.async {
                self.flickrImageView.image = cached
            }
        }else{
            //Load Image from remote URL and cache it on disk
            DispatchQueue.main.async {
                self.flickrImageView.sd_setImage(with: imageUrl)
            }
        }
        DispatchQueue.main.async {
            self.titleLabel.text = model.title
        }
    }
}
