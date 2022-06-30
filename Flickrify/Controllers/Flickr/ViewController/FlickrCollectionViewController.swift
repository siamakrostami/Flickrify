//
//  FlickrCollectionViewController.swift
//  Flickrify
//
//  Created by Siamak Rostami on 6/30/22.
//

import UIKit

class FlickrCollectionViewController: BaseViewController {
    
    @IBOutlet weak var searchTextfield: UITextField!{
        didSet{
            searchTextfield.delegate = self
            searchTextfield.setLeftPaddingPoints(12)
            searchTextfield.setRightPaddingPoints(12)
        }
    }
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!{
        didSet{
            imagesCollectionView.delegate = self
            imagesCollectionView.dataSource = self
            imagesCollectionView.register(UINib(nibName: FlickrCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: FlickrCollectionViewCell.identifier)
            imagesCollectionView.refreshControl = self.refresh
        }
    }
    
    private var viewModel : FlickrViewModel!
    private var refresh = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViewModel()
        self.bindError()
        self.bindLoading()
        self.bindSearchText()
        self.bindCollectionUpdate()
        self.setRefreshController()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    
}

extension FlickrCollectionViewController {
    
    private func initViewModel(){
        self.viewModel = FlickrViewModel()
    }
    
    private func setRefreshController(){
        refresh.addTarget(self, action: #selector(refreshView), for: .valueChanged)
    }
    @objc func refreshView(){
        self.refresh.endRefreshing()
        self.resetPagination()
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
                self.searchTextfield.text = search
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

extension FlickrCollectionViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.updateSearchText(text: textField.text ?? "boston")
        self.view.endEditing(true)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.updateSearchText(text: textField.text ?? "boston")
        self.view.endEditing(true)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.updateSearchText(text: textField.text ?? "boston")
        self.view.endEditing(true)
    }
}

extension FlickrCollectionViewController : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard self.viewModel.photosArray != nil else {
            return 0
        }
        return self.viewModel.photosArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickrCollectionViewCell.identifier, for: indexPath) as? FlickrCollectionViewCell else {return UICollectionViewCell()}
        guard let photData = self.viewModel.photosArray?[indexPath.row] else {return UICollectionViewCell()}
        let photoUrl = self.viewModel.setImageUrlWithModel(model: photData)
        cell.configureCell(imageUrl: photoUrl)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photData = self.viewModel.photosArray?[indexPath.row] else {return}
        let vc = ImageDetailViewController.build(model: photData, viewModel: self.viewModel)
        UIView.transition(from: self.view, to: vc.view, duration: 0.5, options: .transitionFlipFromRight) { _ in
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let count = self.viewModel.photosArray?.count else {return}
        if indexPath.row == count - 1 {
            self.viewModel.fetchNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.bounds.width)/Constants.defaultColumnCount) - 8, height: (collectionView.bounds.width)/Constants.defaultColumnCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}

