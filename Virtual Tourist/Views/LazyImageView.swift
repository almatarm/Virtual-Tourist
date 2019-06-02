//
//  LazyImageView.swift
//  Virtual Tourist
//
//  Created by Mufeed AlMatar on 02/06/2019.
//  Copyright © 2019 Mufeed AlMatar. All rights reserved.
//

import Foundation
import UIKit

class LazyImageView : UIImageView {
    private var photo:Photo! {
        didSet {
            loadImage()
        }
    }
    
    func setPhoto(newPhoto: Photo) {
        photo = (photo == nil ? newPhoto : photo)
    }
    
    func loadImage() {
        updatingUI(loading: true)
        print("loading image")
        
        //Do we have a stored image
        if let imageData = photo.getImageData() {
            self.image = imageData
            updatingUI(loading: false)
            print("image loading from store")
            return
        }
        
        //load image form flicker
        if let url = photo.link {
            getData(from: url) { data, response, error in
                self.updatingUI(loading: false)
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    self.image = UIImage(data: data)
                    self.photo.setImageData(image: self.image!)
                    try? self.photo.managedObjectContext?.save()
                    print("image loaded from fliker")
                }
            }
        } else {
            updatingUI(loading: false)
            print("no image loaded")
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.center = self.center
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)
        return activityIndicator
    }()
    
    func updatingUI(loading: Bool) {
        DispatchQueue.main.async {
            if loading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
}
