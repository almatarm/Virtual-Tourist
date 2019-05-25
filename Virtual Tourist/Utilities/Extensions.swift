//
//  Extensions.swift
//  Virtual Tourist
//
//  Created by Mufeed AlMatar on 25/05/2019.
//  Copyright © 2019 Mufeed AlMatar. All rights reserved.
//

import Foundation
import MapKit

extension MKCoordinateRegion {
    func serialize() -> [Double] {
        return [center.latitude, center.longitude, span.latitudeDelta, span.longitudeDelta]
    }
    
    static func deserialize(_ params: [Double] ) -> MKCoordinateRegion {
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: params[0], longitude: params[1]), span:  MKCoordinateSpan(latitudeDelta: params[2], longitudeDelta: params[3]))
    }
}


