//  Flickrify
//
//  Created by Siamak Rostami on 6/29/22.
//

import Foundation

// MARK: - Photo
struct Photo: Codable {
    var id, owner, secret, server: String?
    var farm: Int?
    var title: String?
    var ispublic, isfriend, isfamily: Int?
}
