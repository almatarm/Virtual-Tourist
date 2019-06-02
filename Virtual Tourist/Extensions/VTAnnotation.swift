//
//  VTAnnotation.swift
//  Virtual Tourist
//
//  Created by Mufeed AlMatar on 01/06/2019.
//  Copyright © 2019 Mufeed AlMatar. All rights reserved.
//

import Foundation
import MapKit

class VTAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pin: Pin?
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    
    init(pin: Pin) {
        self.pin = pin
        self.coordinate = pin.coordinate
    }
}
