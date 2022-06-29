//
//  FlickrCollectionViewController.swift
//  Flickrify
//
//  Created by Siamak Rostami on 6/30/22.
//

import UIKit

class FlickrCollectionViewController: BaseViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            self.searchBar.delegate = self
        }
    }
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    private var viewModel : FlickrViewModel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViewModel()
        self.bindError()
        self.bindLoading()
        self.bindSearchText()
        self.bindCollectionUpdate()
        // Do any additional setup after loading the view.
    }
    

}

extension FlickrCollectionViewController {
    
    private func initViewModel(){
        self.viewModel = FlickrViewModel()
    }
    
    private func bindError(){
        self.viewModel.error
            .subscribe(on: RunLoop.main)
            .sink(receiveValue: { [weak self] error in
                guard let `self` = self , let error = error else {return}
                self.showError(message: error.errorDescription)
            })
            .store(in: &self.viewModel.disposeBag)
    }
    
    private func bindLoading(){
        self.viewModel.isLoading
            .subscribe(on: RunLoop.main)
            .sink { [weak self] isLoading in
                guard let `self` = self else {return}
                if isLoading{
                    self.startAnimating()
                    return
                }
                self.stopAnimating()
            }
            .store(in: &self.viewModel.disposeBag)
    }
    
    private func bindCollectionUpdate(){
        self.viewModel.shouldUpdateCollection
            .subscribe(on: RunLoop.main)
            .sink { [weak self] shouldUpdate in
                guard let `self` = self else {return}
                if shouldUpdate{
                    self.imagesCollectionView.reloadData()
                }
            }
            .store(in: &self.viewModel.disposeBag)
    }
    
    private func bindSearchText(){
        self.viewModel.searchText
            .subscribe(on: RunLoop.main)
            .sink { [weak self] search in
                guard let `self` = self else {return}
                self.searchBar.text = search
            }
            .store(in: &self.viewModel.disposeBag)
    }
    
    private func updateSearchText(text : String?){
        self.viewModel.searchText.send(text)
        self.resetPagination()
    }
    
    private func resetPagination(){
        self.viewModel.resetPagination()
    }

}

extension FlickrCollectionViewController : UISearchBarDelegate {
    
}

extension FlickrCollectionViewController : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}

