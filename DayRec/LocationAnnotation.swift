//
//  LocationAnnotation.swift
//  DayReco
//
//  Created by Victor Wei on 10/5/16.
//  Copyright © 2016 VictorW. All rights reserved.
//

import UIKit
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init (coordinate: CLLocationCoordinate2D, title: String){
        self.coordinate = coordinate
        self.title = title
        super.init()
    }

}
