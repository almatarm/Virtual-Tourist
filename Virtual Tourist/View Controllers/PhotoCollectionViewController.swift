//
//  PhotoCollectionViewController.swift
//  Virtual Tourist
//
//  Created by Mufeed AlMatar on 24/05/2019.
//  Copyright © 2019 Mufeed AlMatar. All rights reserved.
//

import UIKit
import MapKit

class PhotoCollectionViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //MARK: Variables/Constants
    var coordinate: CLLocationCoordinate2D!
    var photos: [URL] = []
    
    
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupMapView()
        FlickrClient.search(lat: coordinate.latitude, lon: coordinate.longitude) { photos, error in
            for photo in photos {
                self.photos.append(photo)
            }
            print(self.photos)
            self.collectionView.reloadData()
        }
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
		
    //MARK: Private methods
    fileprivate func setupMapView() {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: CLLocationDistance(exactly: 7500)!, longitudinalMeters: CLLocationDistance(exactly: 7500)!)
        mapView.setRegion(mapView.regionThatFits(region), animated: false)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    func setupFlowLayout() {
        // show 3 cells in portrait and 5 in landscape mode
        let width = UIDevice.current.orientation.isPortrait ? min(view.frame.size.height, view.frame.size.width) :
            max(view.frame.size.height, view.frame.size.width)
        let cellCount: CGFloat = UIDevice.current.orientation.isPortrait ? 3.0 : 5.0
        let space: CGFloat = cellCount
        let dimension = (width - ((cellCount - 1) * space)) / cellCount
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    @IBAction func newCollection(_ sender: Any) {
        FlickrClient.search(lat: coordinate.latitude, lon: coordinate.longitude) { photos, error in
            self.photos.removeAll()
            for photo in photos {
                self.photos.append(photo)
            }
            print(self.photos)
            self.collectionView.reloadData()
        }
    }
    
    
    //MARK: Delegate methods
}

//MARK: Extensions
extension PhotoCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    static let CellIdentifier = "PhotoCollectionCellIdentifier"
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewController.CellIdentifier, for: indexPath) as! PhotoCollectionViewCell
        
        let photo = photos[indexPath.row]
        downloadImage(from: photo, imageView: cell.photo)
        return cell
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, imageView: UIImageView) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                imageView.image = UIImage(data: data)
            }
        }
    }
}
