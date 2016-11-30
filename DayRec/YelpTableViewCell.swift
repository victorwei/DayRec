//
//  YelpTableViewCell.swift
//  DayReco
//
//  Created by Victor Wei on 10/6/16.
//  Copyright © 2016 VictorW. All rights reserved.
//

import UIKit

class YelpTableViewCell: UITableViewCell {
    
    
    var city = ""
    var businessName = ""
    var businessURL = ""

    @IBOutlet weak var yelpImgView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    
    
    func isYelpInstalled() -> Bool {
        return UIApplication.sharedApplication().canOpenURL(NSURL(string: "yelp:")!)
    }
    
    func getYelpURL() -> String {
        let cityString = city.stringByReplacingOccurrencesOfString(" ", withString: "-")
        let businessString = businessName.stringByReplacingOccurrencesOfString(" ", withString: "-")
        let url = "https://yelp.com/biz/\(businessString)-\(cityString)"
        return url
        
    }
    
    
    func viewYelpInfo () {
        if isYelpInstalled() {
            //open the the yelp application with to view the business
        } else {
            //open a default browser that links to the yelp business
            UIApplication.sharedApplication().openURL(NSURL(string: getYelpURL())!)
        }
        
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
