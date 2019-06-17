//
//  ImageViewController.swift
//  Virtual Tourist
//
//  Created by Mufeed AlMatar on 10/06/2019.
//  Copyright © 2019 Mufeed AlMatar. All rights reserved.
//

import UIKit
import CoreData

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: LazyImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var flickrPhoto: FlickrPhoto?
    var pin: Pin?
    var photo: Photo?
    var viewContext: NSManagedObjectContext {
        return DataController.shared.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.url = flickrPhoto?.url(size: .meidum_800)
        imageView.photo = photo
        imageView.loadImage() {
            self.updateUI()
        }
    }
    
    @IBAction func saveImage(_ sender: Any) {
        photo = Photo(context: viewContext)
        photo?.pin = pin
        photo?.link = flickrPhoto?.url(size: .meidum_800)
        photo?.imageData = imageView.image?.pngData()
        try? viewContext.save()
        updateUI()
    }
    
    @IBAction func deleteImage(_ sender: Any) {
        if let photo = photo {
            viewContext.delete(photo)
            try? viewContext.save()
            self.photo = nil
        }
        updateUI()
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateUI() {
        self.saveButton.isEnabled = self.photo == nil
        self.deleteButton.isEnabled = self.photo != nil
    }
}
