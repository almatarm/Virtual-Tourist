//
//  PhotoCollectionViewController.swift
//  Virtual Tourist
//
//  Created by Mufeed AlMatar on 24/05/2019.
//  Copyright © 2019 Mufeed AlMatar. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoCollectionViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noImageLabel: UILabel!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newCollection: UIBarButtonItem!
    
    //MARK: Variables/Constants
    var pin: Pin!
    var fetchResultsController:NSFetchedResultsController<Photo>!
    var pageNumber = 1
    var viewContext: NSManagedObjectContext!
    var pinHasPhotos: Bool {
        return (fetchResultsController.fetchedObjects?.count ?? 0) > 0
    }
    
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFlowLayout()
        updatingUI(loading: true)
        setupFetchResultsController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchResultsController = nil
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // handle number of cells in flowlayout when device orientation changed
        super.viewWillTransition(to: size, with: coordinator)
        setupFlowLayout()
    }
		
    //MARK: Private methods
    fileprivate func setupMapView() {
        let region = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: CLLocationDistance(exactly: 7500)!, longitudinalMeters: CLLocationDistance(exactly: 7500)!)
        mapView.setRegion(mapView.regionThatFits(region), animated: false)
        let annotation = MKPointAnnotation()
        annotation.coordinate = pin.coordinate
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
//        FlickrClient.search(lat: pin.latitude, lon: pin.longitude) { photos, error in
//            self.photos.removeAll()
//            for photo in photos {
//                self.photos.append(photo)
//            }
//            print(self.photos)
//            self.collectionView.reloadData()
//        }
    }
    
    func fetchNewCollection() {
        updatingUI(loading: true)
        
        
        updatingUI(loading: false)
    }

    func updatingUI(loading: Bool) {
        newCollection.isEnabled = loading == false
        
        if loading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    fileprivate func setupFetchResultsController() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending:  false)]
        fetchRequest.predicate = NSPredicate(format: "pin == %@", pin)
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController.delegate = self
        do {
            try fetchResultsController.performFetch()
            if !pinHasPhotos {
                // Get Photos form flicker
                FlickrClient.search(lat: pin.latitude, lon: pin.longitude, page: pageNumber) { urls, error in
                    for url in urls {
                        let photo = Photo(context: self.viewContext)
                        photo.link = url
                        photo.pin = self.pin
                    }
                    try? self.viewContext.save()
                    self.pageNumber += 1
                    self.collectionView.reloadData()
                }
            }
        } catch {
            fatalError("Could not fetch photos from local store: \(error.localizedDescription)")
        }
        
        updatingUI(loading: false)
    }
    
    //MARK: Delegate methods
}

//MARK: Extensions
extension PhotoCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    static let CellIdentifier = "PhotoCollectionCellIdentifier"
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewController.CellIdentifier, for: indexPath) as! PhotoCollectionViewCell
        
        let photo = fetchResultsController.object(at: indexPath)
        cell.photo.setPhoto(newPhoto: photo)
        return cell
    }
    
    
}

extension PhotoCollectionViewController : NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
        case .insert:
            if let indexPath = indexPath {
                collectionView.insertItems(at: [indexPath])
            }
        default:
            break
        }
    }
}
