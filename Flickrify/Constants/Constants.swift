//
//  Constants.swift
//  Flickrify
//
//  Created by Siamak Rostami on 6/30/22.
//

import Foundation
import UIKit

class Constants {
    static let api_key = "417a9ad6bdde0789bf2e1ad93ee89f00"
    static let per_page = 20
    static let baseUrl = "https://www.flickr.com/"
    static let imageURL = "https://farm%d.staticflickr.com/%@/%@_%@_\(Constants.size.url_l.value).jpg"
    
    enum size: String {
        case url_sq = "s"   //small square 75x75
        case url_q = "q"    //large square 150x150
        case url_t = "t"    //thumbnail, 100 on longest side
        case url_s = "m"    //small, 240 on longest side
        case url_n = "n"    //small, 320 on longest side
        case url_m = "-"    //medium, 500 on longest side
        case url_z = "z"    //medium 640, 640 on longest side
        case url_c = "c"    //medium 800, 800 on longest side†
        case url_l = "b"    //large, 1024 on longest side*
        case url_h = "h"    //large 1600, 1600 on longest side†
        case url_k = "k"    //large 2048, 2048 on longest side†
        case url_o = "o"    //original image, either a jpg, gif or png, depending on source format
        
        var value: String {
            return self.rawValue
        }
    }
    
    static let defaultColumnCount: CGFloat = 3.0
}
