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
}

class FlickrViewModel {
    
    var photos = CurrentValueSubject<[FlickrDataModel]?,Never>(nil)
    private var photosArray = [FlickrDataModel]()
    var searchText = CurrentValueSubject<String?,Never>(nil)
    var currentPage = 1
    var totalPages = 1
    var error = CurrentValueSubject<ClientError?,Never>(nil)
    private var client : FlickrServices
    var isLoading = CurrentValueSubject<Bool,Never>(false)
    
    init(service : FlickrServices = FlickrServices()){
        self.client = service
    }

}

extension FlickrViewModel : FlickrViewModelProtocols {
    func fetchFlickrImages(searchText: String?, page: Int) {
        self.isLoading.send(true)
        client.flickrService.fetchFlickrImages(searchText: searchText, page: page) { [weak self] flickrData in
            guard let `self` = self else {return}
            switch flickrData{
            case .success(let model):
                self.isLoading.send(false)
                if let model = model{
                    self.totalPages = model.photos?.pages ?? 1
                    self.photosArray.append(model)
                }
                self.photos.send(self.photosArray)
            case .failure(let error):
                self.isLoading.send(false)
                self.error.send(error)
            }
        }
    }
    
    func fetchNextPage() {
        if currentPage < totalPages {
            currentPage += 1
            self.fetchFlickrImages(searchText: self.searchText.value, page: self.currentPage)
        }
    }
    
    func resetPagination() {
        self.currentPage = 1
        self.totalPages = 1
        self.photosArray.removeAll()
        self.photos.send(nil)
        self.searchText.send(nil)
    }
    
    
}
