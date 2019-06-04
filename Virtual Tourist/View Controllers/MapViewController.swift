//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Mufeed AlMatar on 2019-05-13.
//  Copyright © 2019 Mufeed AlMatar. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, UIGestureRecognizerDelegate, NSFetchedResultsControllerDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: Variables/Constants
    var dataController:DataController = DataController.shared
    var viewContext: NSManagedObjectContext {
        return dataController.viewContext
    }
    var fetchResultsController:NSFetchedResultsController<Pin>!
    var lastAddedAnnotation: MKPointAnnotation?
    
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        setupMapLongPressGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if let region_array = UserDefaults.standard.value(forKey: Constants.MAP_REGION) as? [Double] {
            mapView.setRegion(MKCoordinateRegion.deserialize(region_array), animated:  true)
        }
        setupFetchResultsController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        fetchResultsController = nil
    }
    
    //MARK: Private methods
    fileprivate func setupMapLongPressGesture() {
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.mapTapped(gestureReconizer:)))
        tapGesture.delegate = self
        mapView.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func setupFetchResultsController() {
        let pinFetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        pinFetchRequest.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchResultsController = NSFetchedResultsController(fetchRequest: pinFetchRequest, managedObjectContext: viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController.delegate = self
        do {
            try fetchResultsController.performFetch()
            refresh()
        } catch {
            alert(message: error.localizedDescription, title: "Loading Pins")
        }
    }
    
    func refresh() {
        mapView.removeAnnotations(mapView.annotations)
        guard let pins = fetchResultsController.fetchedObjects else {return}
        for pin in pins {
            addAnnotation(pin: pin)
        }
    }
    
    func addPin(coordinate: CLLocationCoordinate2D) -> Pin {
        let pin = Pin(context: viewContext)
        pin.coordinate = coordinate
        try? viewContext.save()
        return pin
    }
    
    func addAnnotation(pin: Pin) {
        // Add annotation:
        let annotation = VTAnnotation(pin: pin)
        mapView.addAnnotation(annotation)
    }
    
    //MARK: Delegate methods
    @objc func mapTapped(gestureReconizer: UILongPressGestureRecognizer) {
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        if gestureReconizer.state == .began {
            lastAddedAnnotation = MKPointAnnotation()
            lastAddedAnnotation?.coordinate = coordinate
            mapView.addAnnotation(lastAddedAnnotation!)
        } else if gestureReconizer.state == .changed {
            lastAddedAnnotation?.coordinate = coordinate
        } else if gestureReconizer.state == .ended {
            mapView.removeAnnotation(lastAddedAnnotation!)
            let pin = addPin(coordinate: coordinate)
            addAnnotation(pin: pin)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        refresh()
    }
    
}

//MARK: Extensions - MapView Delegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        try? viewContext.save()
        let pin = fetchResultsController.fetchedObjects?.filter {
            $0.equalsTo(coordinate: view.annotation!.coordinate)
        }.first!
        let photoCollectionVC = self.storyboard?.instantiateViewController(withIdentifier: "PhotoCollectionViewController") as! PhotoCollectionViewController
        photoCollectionVC.pin = pin //(view.annotation as? VTAnnotation)?.pin
        try? viewContext.save()
        self.navigationController?.pushViewController(photoCollectionVC, animated: true)
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        UserDefaults.standard.set(mapView.region.serialize(), forKey: Constants.MAP_REGION)
    }
}
