//  Flickrify
//
//  Created by Siamak Rostami on 6/29/22.
//

import Foundation

// MARK: - Photos
struct Photos: Codable {
    var page: Int?
    var pages: Int?
    var perpage: Int?
    var total: Int?
    var photo: [Photo]?
}
