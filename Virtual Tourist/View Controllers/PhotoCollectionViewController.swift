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
    enum UIEvent {
        case beginLoadingImages, endLoadingImages, beginLoadingNewImage, endLoadingNewImage
    }
    
    //MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noImageLabel: UILabel!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Variables/Constants
    var pin: Pin!
    var fetchResultsController:NSFetchedResultsController<Photo>!
    var viewContext: NSManagedObjectContext {
        return DataController.shared.viewContext
    }
    var havePhotos: Bool {
        return (fetchResultsController?.fetchedObjects?.count ?? 0) > 0
    }
    var numberOfImagesCurrentlyLoading = 0
    var deletingAllImagesInProgress = false
    
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
        setupFetchResultsController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        try? viewContext.save()
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
        let space: CGFloat = cellCount * 2
        let dimension = (width - ((cellCount - 1) * space)) / cellCount
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    func updateUI(event: UIEvent) {
        switch(event) {
        case .beginLoadingImages:
//            nextCollection.isEnabled = false
            activityIndicator.startAnimating()
            break
        case .endLoadingImages:
//            nextCollection.isEnabled = true
            activityIndicator.stopAnimating()
//            pageLabel.text = "\(pageNumber)/\(pageCount)"
//            print(pageNumber, pageCount, pageNumber < pageCount)
//            nextCollection.isEnabled = pageNumber < pageCount
//            prevCollection.isEnabled = pageNumber > 1
            noImageLabel.isHidden = havePhotos
            try? viewContext.save()
            break
        case .beginLoadingNewImage:
            numberOfImagesCurrentlyLoading += 1
            updateUI(event: .beginLoadingImages)
            break
        case .endLoadingNewImage:
            numberOfImagesCurrentlyLoading -= 1
            if numberOfImagesCurrentlyLoading == 0 {
                updateUI(event: .endLoadingImages)
            }
            break
        }
    }
    
    fileprivate func setupFetchResultsController() {
        updateUI(event: .beginLoadingImages)
        
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending:  false)]
        fetchRequest.predicate = NSPredicate(format: "pin == %@", pin)
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController.delegate = self
        do {
            try fetchResultsController.performFetch()
            updateUI(event: .endLoadingImages)
            
            if !havePhotos {
                shouldGetPhotos()
            }
        } catch {
            fatalError("Could not fetch photos from local store: \(error.localizedDescription)")
        }
    }
    
    func shouldGetPhotos() {
        let getPhotosAlert = UIAlertController(title: "Get Photos", message: "No saved images in this location. get new photos?", preferredStyle: UIAlertController.Style.alert)
        
        getPhotosAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.getPhotos()
        }))
        
        getPhotosAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(getPhotosAlert, animated: true, completion: nil)
    }
    
    @IBAction func getPhotos() {
        let photoPickerVC = self.storyboard?.instantiateViewController(withIdentifier: "PhotoPickerViewController") as! PhotoPickerViewController
        photoPickerVC.pin = pin //(view.annotation as? VTAnnotation)?.pin
//        try? viewContext.save()
        self.navigationController?.pushViewController(photoPickerVC, animated: true)
    }
    
    @IBAction func deletePin(_ sender: Any) {
        deletingAllImagesInProgress = true
        viewContext.delete(pin)
        try? viewContext.save()
        self.navigationController?.popViewController(animated: true)
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
        updateUI(event: .beginLoadingNewImage)
        cell.photo.setPhoto(newPhoto: photo) {
            DispatchQueue.main.async {
                self.updateUI(event: .endLoadingNewImage)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = fetchResultsController.object(at: indexPath)
        let imageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        imageViewController.photo = photo
        self.navigationController?.pushViewController(imageViewController, animated: true)
    }
    
}

extension PhotoCollectionViewController : NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
        case .insert:
            if let indexPath = indexPath {
                collectionView.insertItems(at: [indexPath])
            }
        case .delete:
            if let indexPath = indexPath, !deletingAllImagesInProgress {
                collectionView.deleteItems(at: [indexPath])
            }
        default:
            break
        }
        
    }
}
