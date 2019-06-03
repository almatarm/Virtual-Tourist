//
//  Pin.swift
//  Virtual Tourist
//
//  Created by Mufeed AlMatar on 02/06/2019.
//  Copyright © 2019 Mufeed AlMatar. All rights reserved.
//

import Foundation
import MapKit

extension Pin {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
    
    func equalsTo(coordinate: CLLocationCoordinate2D) -> Bool {
        return coordinate.latitude == latitude && coordinate.longitude == longitude
    }
}
