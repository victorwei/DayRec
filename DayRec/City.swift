//
//  City.swift
//  DayRec
//
//  Created by Victor Wei on 10/7/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit

class City: NSObject {
    
    var name: String!
    var latitude: Double!
    var longitude: Double!
    
    init(name: String, lat: Double, lng: Double){
        self.name = name
        self.latitude = lat
        self.longitude = lng
    }

}
