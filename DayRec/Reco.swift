//
//  Reco.swift
//  DayReco
//
//  Created by Victor Wei on 10/2/16.
//  Copyright © 2016 VictorW. All rights reserved.
//

import UIKit

class Reco: NSObject {
    
    var locationArray: [NSDictionary] = []
    var restaurantArray: [NSDictionary] = []
    var category: String = ""
    var dayPlan: String = ""
    var shortDescription: String = ""
    var city: String!
    var recoId: Int!
    var userId: Int!
    
    
    init(description: String, category: String, dayPlan: String, city: String, recoId: Int, userId: Int){
        self.shortDescription = description
        self.category = category
        self.dayPlan = dayPlan
//        self.locationArray = locations
//        self.restaurantArray = restaurants
        self.city = city
        self.recoId = recoId
        self.userId = userId
    }
    
    
    

}
