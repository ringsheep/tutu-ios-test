//
//  GZ_MapPin.swift
//  Tutu iOS Test
//
//  Created by George Zinyakov on 6/16/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import UIKit
import MapKit

class GZ_MapPin: NSObject, MKAnnotation
{
    let coordinate: CLLocationCoordinate2D
    
    init(latitude : Double , longitude : Double) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.coordinate = coordinate
        super.init()
    }
    
}
