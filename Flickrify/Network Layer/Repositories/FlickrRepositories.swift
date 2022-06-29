//
//  FlickrRepositories.swift
//  Flickrify
//
//  Created by Siamak Rostami on 6/30/22.
//

import Foundation
import Alamofire

typealias FlickrCompletion = ((Result<FlickrDataModel?,ClientError>) -> Void)

protocol FlickrRepositoriesProtcols {
    func fetchFlickrImages(searchText : String? , page : Int , completion:@escaping FlickrCompletion)
}



class FlickrRepositories {
    private let client : APIClient
    init(client : APIClient = APIClient()){
        self.client = client
    }
}

extension FlickrRepositories : FlickrRepositoriesProtcols{
    func fetchFlickrImages(searchText: String?, page: Int, completion: @escaping FlickrCompletion) {
        client.request(Router.fetchImages(searchText: searchText, page: page), result: completion)
    }
    
    
}

extension FlickrRepositories {
    
    enum Router : NetworkRouter {
        case fetchImages(searchText : String? , page : Int)
        
        var method: RequestMethod?{
            return .get
        }
        var baseURLString: String{
            return Constants.baseUrl
        }
        var encoding: ParameterEncoding?{
            return JSONEncoding.default
        }
        var isURLEncoded: Bool{
            return false
        }
        var path: String{
            return Constants.searchURL
        }
        
    }
    
    
}
