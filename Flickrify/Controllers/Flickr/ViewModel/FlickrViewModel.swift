//
//  FlickrViewModel.swift
//  Flickrify
//
//  Created by Siamak Rostami on 6/30/22.
//

import Foundation
import Combine

protocol FlickrViewModelProtocols{
    func fetchFlickrImages(searchText : String? , page : Int)
    func fetchNextPage()
    func resetPagination()
    func fetchFlickrData()
}

class FlickrViewModel {
    
    var shouldUpdateCollection = CurrentValueSubject<Bool,Never>(false)
    private var photos : FlickrDataModel?
    var photosArray : [Photo]?
    var searchText = CurrentValueSubject<String?,Never>(nil)
    var currentPage = 1
    var totalPages = 1
    var error = CurrentValueSubject<ClientError?,Never>(nil)
    private var client : FlickrServices
    var isLoading = CurrentValueSubject<Bool,Never>(false)
    var disposeBag : Set<AnyCancellable> = []
    
    init(service : FlickrServices = FlickrServices()){
        self.client = service
        self.fetchFlickrData()
        self.searchText.send("boston")
    }
    
}

extension FlickrViewModel : FlickrViewModelProtocols {
    func fetchFlickrData() {
        self.fetchFlickrImages(searchText: self.searchText.value, page: self.currentPage)
    }
    
    internal func fetchFlickrImages(searchText: String?, page: Int) {
        self.isLoading.send(true)
        client.flickrService.fetchFlickrImages(searchText: searchText, page: page) { [weak self] flickrData in
            guard let `self` = self else {return}
            switch flickrData{
            case .success(let model):
                self.isLoading.send(false)
                if let model = model{
                    self.totalPages = model.photos?.pages ?? 1
                    self.photos = model
                    if self.photosArray == nil {
                        self.photosArray = [Photo]()
                    }
                    if let photo = model.photos?.photo {
                        for item in photo{
                            self.photosArray?.append(item)
                        }
                    }
                }
                self.shouldUpdateCollection.send(true)
            case .failure(let error):
                self.shouldUpdateCollection.send(false)
                self.isLoading.send(false)
                self.error.send(error)
            }
        }
    }
    
    func fetchNextPage() {
        if currentPage < totalPages {
            currentPage += 1
            self.fetchFlickrData()
        }
    }
    
    func resetPagination() {
        self.currentPage = 1
        self.totalPages = 1
        if photosArray != nil{
            self.photosArray?.removeAll()
            self.photosArray = nil
        }
        if photos != nil{
            self.photos = nil
        }
        self.shouldUpdateCollection.send(true)
        self.fetchFlickrData()
    }
    
    func setImageUrlWithModel(model : Photo) -> URL?{
        guard let farm = model.farm , let server = model.server , let secret = model.secret , let id = model.id else {return nil}
        let urlString = String(format: Constants.imageURL, farm, server, id, secret)
        return URL(string: urlString)
    }
    
    
}
