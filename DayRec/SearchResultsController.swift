//
//  SearchResultsController.swift
//  DayReco
//
//  Created by Victor Wei on 10/6/16.
//  Copyright © 2016 VictorW. All rights reserved.
//

import UIKit

protocol LocateOnMap : NSObjectProtocol{
    func locateWithCoordinates(latitude: Double, longitude: Double, title: String, data: NSDictionary)
}

//Search Results formed as a tableViewcontroller
class SearchResultsController: UITableViewController {
    
    var searchResults: [String]!
    var delegate: LocateOnMap!
    var city: City!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the serach results to an empty array and register a default tableViewcell
        self.searchResults = Array()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "myCell")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    //set the text label as each search resut
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath)
        cell.textLabel?.text = self.searchResults[indexPath.row]
        return cell
    }
    
    
    //If user selects the row, dismiss the view controller and send the selection data by delegate/protocol
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        self.dismissViewControllerAnimated(true, completion: nil)
        getLocationInfo(searchResults[indexPath.row], latitude: city.latitude, longitude: city.longitude) { (result, latitude, longitude, data) in
            if result {
                let title = data["name"] as! String
                self.delegate.locateWithCoordinates(latitude, longitude: longitude, title: title, data: data)
            }
        }
        
        
    }
    
    
    
    //Helper function to get location information of the search object
    func getLocationInfo(address: String,  latitude: Double, longitude: Double ,completion: (result: Bool, latitude: Double, longitude: Double, data: NSDictionary)->()) {
        
        
        let correctString = address.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        let realURL = NSURL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=15000&name=\(correctString)&key=AIzaSyDe1KKF2WEJoIpU_tS35KmTb82MzXGgjSQ")
        let totalString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=18000&name=\(correctString)&key=AIzaSyDe1KKF2WEJoIpU_tS35KmTb82MzXGgjSQ"
        let regularURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=18000&name=\(address)&key=AIzaSyDe1KKF2WEJoIpU_tS35KmTb82MzXGgjSQ"
        
        let url: NSString = regularURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let searchURL = NSURL(string: url as String)
        
        
        //get the data of the url in a NSData format
        let data = NSData(contentsOfURL: searchURL!)
        //get the json data as a NSDictionary object
        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
        
        //parse the json result to grab the latitude and longitude values
        if let result = json["results"] as? NSArray {
            if let geometry = result[0]["geometry"] as? NSDictionary {
                if let location = geometry["location"] as? NSDictionary {
                    //get the latitude and longitude values
                    let latitudeVal = location["lat"] as! Double
                    let longitudeVal = location["lng"] as! Double
                    
                    let jsonData = json["results"]![0] as! NSDictionary
                    //send the values to the completion closure
                    completion(result: true, latitude: latitudeVal, longitude: longitudeVal, data: jsonData )
                }
            }
        }
    }
    
    //Reload the tableView results
    func reloadDataWithArray(array:[String]){
        self.searchResults = array
        self.tableView.reloadData()
    }
        
}
