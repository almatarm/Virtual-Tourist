//
//  ImageViewController.swift
//  Virtual Tourist
//
//  Created by Mufeed AlMatar on 10/06/2019.
//  Copyright © 2019 Mufeed AlMatar. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: LazyImageView!

    var flickrPhoto: FlickrPhoto?
    var photo: Photo?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.url = flickrPhoto?.url(size: .meidum_800)
        imageView.photo = photo
        imageView.loadImage() {
            
        }
    }
    
    @IBAction func saveImage(_ sender: Any) {
        
    }
}
