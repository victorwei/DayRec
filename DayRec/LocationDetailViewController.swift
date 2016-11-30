//
//  LocationDetailViewController.swift
//  DayReco
//
//  Created by Victor Wei on 10/5/16.
//  Copyright © 2016 VictorW. All rights reserved.
//

import UIKit
import MapKit

class LocationDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    var locationDetails: Dictionary<String, AnyObject>!
    var locationData: NSDictionary!
    var locationLabelInfo: [String] = []
    var locationType: [String] = []
    var locationAdapter: GetLocationInfoAdapter!
    
    var sections: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set the initial sections of the table
        sections = ["picture", "information", "map"]
        locationAdapter = GetLocationInfoAdapter(city: "")
        //setup the tableView
        setupTableView()
        //set the title of the navigation bar to a white color
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    //Get Row Count.  Go through the location dictionary to determine which values are empty.  If the values are not empty, add them to a local array
    func getRowCount() -> Int {
        var count = 0
        if locationDetails["name"] as! String != "" {
            count += 1
            locationLabelInfo.append(locationDetails["name"] as! String)
            locationType.append("name")
        }
        if locationDetails["address"] as! String != "" {
            count += 1
            locationLabelInfo.append(locationDetails["address"] as! String)
            locationType.append("address")
        }
        if locationDetails["website"] as! String != "" {
            count += 1
            locationLabelInfo.append(locationDetails["website"] as! String)
            locationType.append("website")
        }
        if locationDetails["phonenumber"] as! String != "" {
            count += 1
            locationLabelInfo.append(locationDetails["phonenumber"] as! String)
            locationType.append("phonenumber")
        }
        //Get the price and change it to a value denoted by $$$$
        if locationDetails["price"] as! Int != 0 {
            count += 1
            var priceString = ""
            let priceInt = locationDetails["price"] as! Int
            for _ in 0..<priceInt {
                priceString += "$"
            }
            locationLabelInfo.append(priceString)
            locationType.append("price")
        }
    
        if locationDetails["rating"] as! String != "" {
            count += 1
            locationLabelInfo.append(locationDetails["rating"] as! String)
            locationType.append("rating")
        }
        if let availability = locationDetails["availability"] as? [String] {
            if availability.count != 0 {
                count += 1
                
                var availabilityString = ""
                for index in availability {
                    availabilityString += index + "\n"
                }
                locationLabelInfo.append(availabilityString)
            }
            locationType.append("availability")
        }
        
        return count
    }
    
    //Setup the tableView.
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "myCellId")
        
        //set up tableviewcell for image
        let imgNibFile = UINib(nibName: "ImageTableViewCell", bundle: nil)
        tableView.registerNib(imgNibFile, forCellReuseIdentifier: "ImageTableViewCell")
        
        
        //set up map cell
        let mapNibFile = UINib(nibName: "MapTableViewCell", bundle: nil)
        tableView.registerNib((mapNibFile), forCellReuseIdentifier: "MapTableViewCell")
        
        
        //set up the detail label tableviewcell
        let detaillabelNibFile = UINib(nibName: "DetailLabelTableViewCell", bundle: nil)
        tableView.registerNib(detaillabelNibFile, forCellReuseIdentifier: "DetailLabelTableViewCell")
        
        //setup the yelp tableviewCell
        let yelpNibFile = UINib(nibName: "YelpTableViewCell", bundle: nil)
        tableView.registerNib(yelpNibFile, forCellReuseIdentifier: "YelpTableViewCell")
        
        //set up google map cell
        let googleMapNibFile = UINib(nibName: "GoogleMapLocationTableViewCell", bundle: nil)
        tableView.registerNib(googleMapNibFile, forCellReuseIdentifier: "GoogleMapLocationTableViewCell")
        
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
    }
    
    
    //Set the height for each row
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return (view.frame.width * 0.7)
        } else if indexPath.section == 2 {
            return (view.frame.width)
        }
        return UITableViewAutomaticDimension
    }
    
    //return number of sections in the table
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    //return number of rows for each section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //Section 1 holds all the detail information.  Everything else is just a map or image
        if section == 1 {
            return getRowCount()
        } else {
            return 1
        }
        
    }
    
    //return what to display for each cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Show an image of the cell
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ImageTableViewCell", forIndexPath: indexPath) as! ImageTableViewCell
            //Get the picture for the location and set the imageview's image to the picture
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let data = self.locationAdapter.getPictureForLocation(Int(cell.frame.width), data: self.locationData)
                dispatch_async(dispatch_get_main_queue(), {
                    cell.imgView.image = UIImage(data: data!)
                })
            }
            //set the image
            let image = UIImage(data: locationDetails["image"] as! NSData)
            cell.imgView.image = image
            return cell
        
            //Display all the information regarding the place
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("DetailLabelTableViewCell", forIndexPath: indexPath) as! DetailLabelTableViewCell
            //set the text to the corresponding location information
            cell.detailLabel.text = locationLabelInfo[indexPath.row]
            
            if indexPath.row == 0 {
                //cell.detailLabel.font = cell.detailLabel.font.fontWithSize(20)
                cell.detailLabel.font = UIFont.boldSystemFontOfSize(20)
            }
            //set whihc info icon to display based on which information is displayed
            switch locationType[indexPath.row] {
                case "address":
                    cell.iconImage.image = UIImage(named: "address")
                case "website":
                    cell.iconImage.image = UIImage(named: "website")
                case "phonenumber":
                    cell.iconImage.image = UIImage(named: "phone")
                case "price":
                    cell.iconImage.image = UIImage(named: "price")
                case "rating":
                    cell.iconImage.image = UIImage(named: "rating")
                case "availability":
                    cell.iconImage.image = UIImage(named: "availability")
                default:
                    cell.iconImage.hidden = true
            }
            
            return cell
          
            
            //Show the map of the table view cell
        } else if indexPath.section == 2 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("GoogleMapLocationTableViewCell", forIndexPath: indexPath) as! GoogleMapLocationTableViewCell
            //update the cell to show the location map information
            cell.locationDetails = locationDetails
            cell.updateView()
            
            return cell
            
          //default case
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("myCellId", forIndexPath: indexPath)
            return cell
        }
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
