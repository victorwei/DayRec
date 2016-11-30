//
//  User.swift
//  DayReco
//
//  Created by Victor Wei on 10/6/16.
//  Copyright © 2016 VictorW. All rights reserved.
//

import UIKit

class User: NSObject {
    
    static let sharedInstance = User()
    private override init() {}
    
    var fName: String!
    var lName: String!
    var password: String!
    var userId: Int!
    var email: String!
    var reviews: Int!
    var picture: String!
    var bio: String!
    
    
    

}
