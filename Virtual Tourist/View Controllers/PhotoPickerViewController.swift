//
//  PhotoPickerViewController.swift
//  Virtual Tourist
//
//  Created by Mufeed AlMatar on 15/06/2019.
//  Copyright © 2019 Mufeed AlMatar. All rights reserved.
//

import UIKit
import CoreData

class PhotoPickerViewController: UIViewController {

    enum UIEvent {
        case beginLoadingImages, endLoadingImages, beginLoadingNewImage, endLoadingNewImage
    }
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noImageLabel: UILabel!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var nextCollection: UIBarButtonItem!
    @IBOutlet weak var prevCollection: UIBarButtonItem!
    @IBOutlet weak var pageLabel: UILabel!
    
    //MARK: Variables/Constants
    var pin: Pin!
    var pageNumber = 0
    var pageCount = 0
    var photos: [FlickrPhoto] = []
    var havePhotos: Bool {
        return photos.count > 0
    }
    var numberOfImagesCurrentlyLoading = 0
    var deletingAllImagesInProgress = false
    
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        newCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFlowLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // handle number of cells in flowlayout when device orientation changed
        super.viewWillTransition(to: size, with: coordinator)
        setupFlowLayout()
    }
    
    func setupFlowLayout() {
        // show 3 cells in portrait and 5 in landscape mode
        let width = UIDevice.current.orientation.isPortrait ? min(view.frame.size.height, view.frame.size.width) :
            max(view.frame.size.height, view.frame.size.width)
        let cellCount: CGFloat = UIDevice.current.orientation.isPortrait ? 3.0 : 5.0
        let space: CGFloat = cellCount * 2
        let dimension = (width - ((cellCount - 1) * space)) / cellCount
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    
    @IBAction func nextCollection(_ sender: Any) {
        pageNumber += 1
        newCollection()
    }
    
    @IBAction func prevCollection(_ sender: Any) {
        pageNumber -= 1
        newCollection()
    }
    
    func newCollection() {
        // Get Photos form flicker
        updateUI(event: .beginLoadingImages)
        photos.removeAll()
        
        FlickrClient.search(lat: pin.latitude, lon: pin.longitude, page: pageNumber) { searchResult, error in
            guard let flikerPhotos = searchResult?.photos else { return }
            for flickrPhoto in flikerPhotos {
                self.photos.append(flickrPhoto)
            }
            self.pageNumber = searchResult?.page ?? 0
            self.pageCount = searchResult?.pages ?? 0
            self.collectionView.reloadData()
            self.updateUI(event: .endLoadingImages)
        }
    }
    
    func updateUI(event: UIEvent) {
        switch(event) {
        case .beginLoadingImages:
            nextCollection.isEnabled = false
            activityIndicator.startAnimating()
            break
        case .endLoadingImages:
            nextCollection.isEnabled = true
            activityIndicator.stopAnimating()
            nextCollection.isEnabled = pageNumber < pageCount
            prevCollection.isEnabled = pageNumber > 1
            noImageLabel.isHidden = havePhotos
            break
        case .beginLoadingNewImage:
            numberOfImagesCurrentlyLoading += 1
            updateUI(event: .beginLoadingImages)
            break
        case .endLoadingNewImage:
            numberOfImagesCurrentlyLoading -= 1
            nextCollection.isEnabled = pageNumber < pageCount
            prevCollection.isEnabled = pageNumber > 1
            pageLabel.text = "\(pageNumber)/\(pageCount)"
            if numberOfImagesCurrentlyLoading == 0 {
                updateUI(event: .endLoadingImages)
            }
            break
        }
    }

    //MARK: Delegate methods
}

//MARK: Extensions
extension PhotoPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    static let CellIdentifier = "PhotoCollectionCellIdentifier"
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewController.CellIdentifier, for: indexPath) as! PhotoCollectionViewCell
        
        let photo = photos[indexPath.row]
        updateUI(event: .beginLoadingNewImage)
        cell.photo.url = photo.url(size: .thumbnail)
        cell.photo.loadImage() {
            DispatchQueue.main.async {
                self.updateUI(event: .endLoadingNewImage)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let flickrPhoto = photos[indexPath.row]
        let imageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        imageViewController.flickrPhoto = flickrPhoto
        imageViewController.pin = pin
        self.navigationController?.pushViewController(imageViewController, animated: true)
    }
    
}
