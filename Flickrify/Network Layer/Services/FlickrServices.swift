//
//  FlickrServices.swift
//  Flickrify
//
//  Created by Siamak Rostami on 6/30/22.
//

import Foundation

struct FlickrServices {
    var flickrService : FlickrRepositories = {
        return FlickrRepositories()
    }()
}
