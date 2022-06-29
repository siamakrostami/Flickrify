//
//  BaseViewController.swift
//  Flickrify
//
//  Created by Siamak Rostami on 6/30/22.
//

import UIKit

class BaseViewController: UIViewController {
    
    private let indicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.center = view.center
        view.addSubview(indicator)

        // Do any additional setup after loading the view.
    }
    
    func startAnimating(){
        self.indicator.startAnimating()
    }
    func stopAnimating(){
        self.indicator.stopAnimating()
    }
    
    func showError(message : String?){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    


}
