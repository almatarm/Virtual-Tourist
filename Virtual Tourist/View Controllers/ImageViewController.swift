//
//  ImageViewController.swift
//  Virtual Tourist
//
//  Created by Mufeed AlMatar on 10/06/2019.
//  Copyright © 2019 Mufeed AlMatar. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = photo.getDifferentSize(size: .meidum_800)
        getData(from: url!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                let newImage = UIImage(data: data)
                self.imageView.image = newImage
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}
