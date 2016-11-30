//
//  PreviewRecoViewController.swift
//  DayReco
//
//  Created by Victor Wei on 10/2/16.
//  Copyright © 2016 VictorW. All rights reserved.
//

import UIKit

class PreviewRecoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ratingChanged{

    //MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    var recommendation: Reco!
    var locationInfoAdapater: GetLocationInfoAdapter!
    var sectionHeaders : [String] = []
    //Dictionary objects that hold information on each location/restaurant
    var locationDetails : [Dictionary<String, AnyObject>] = []
    var RestaurantDetails : [Dictionary <String, AnyObject>] = []
    var locationsArray: [NSDictionary]!
    
    var locationData: [NSDictionary] = []
    var restaurantData: [NSDictionary] = []
    var city: City!
    var database: sqlDB!
    var editRating = false


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up the database
        database = sqlDB()
        //Initial section headers
        sectionHeaders = ["User", "Title", "Day Recommendation"] //, "Point of Interests", "Food/Drinks"]
        
        //Get the location data based on the reco
        getLocations()
        
        //setup the tableView
        setupTableView()
        
        //set the navigation title
        navigationItem.title = city.name
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Helper function to get the locations of the current reco
    func getLocations() {
        
        //set the locationInfoAdapter to the correct city
        locationInfoAdapater = GetLocationInfoAdapter(city: recommendation.city)
        locationInfoAdapater.getCityLocation { (result, latitude, longitude) in
            if true {
                self.city = City(name: self.recommendation.city, lat: latitude, lng: longitude)
            }
        }
        
        //get all locations based on the recoid
        let locations = database.getLocationsForReco(recommendation.recoId)
        //Go through each location and get the information
        for location in locations {
            let placeId = location[1] as! String
            //Get a more specific json result based on the placeId of the location
            locationInfoAdapater.getLocationDetailFromPlaceId(placeId, completion: { (result, data) in
                //get the detail information and append it to the local variables
                self.locationData.append(data)
                let result = self.locationInfoAdapater.getLocationDetailsAllInformation(data)
                self.locationDetails.append(result)
                
            })
        }
        
        //get restaurant data based on reco id
        let restaurants = database.getRestaurantsForReco(recommendation.recoId)
        //go through each restaurant and get the information and append it to the local variables
        for restaurant in restaurants {
            let placeId = restaurant[1] as! String
            locationInfoAdapater.getLocationDetailFromPlaceId(placeId, completion: { (result, data) in
                self.restaurantData.append(data)
                let result = self.locationInfoAdapater.getLocationDetailsAllInformation(data)
                self.RestaurantDetails.append(result)
                
            })
        }
        //Add sections based on results of location and restaurants
        if locations.count != 0 {
            sectionHeaders.append("Point of Interests")
        }
        if restaurants.count != 0 {
            sectionHeaders.append("Food/Drinks")
        }
        
        sectionHeaders.append("Rating")
        
    }
    

    
    //Helper function to get the user's information to display in a cell
    func getUserData () -> (String, String, String) {
        let userdata = database.getUserDataFromId(recommendation.userId)
        let firstName = userdata[1] as! String
        let lastName = userdata [2] as! String
        let lastInitial = String(lastName[lastName.startIndex])
        let name = firstName + " " + lastInitial + "."
        let image = userdata[4] as! String
        let bio = userdata[3] as! String
        return (name, image, bio)
        
    }
    
    
    

    
    //setup tableView
    
    func setupTableView () {
        //setup delegate and dataSource
        tableView.delegate = self
        tableView.dataSource = self
        
        //setup the label cell to use for rec's title/description
        let titleNibFile = UINib(nibName: "DescriptionTableViewCell", bundle: nil)
        tableView.registerNib(titleNibFile, forCellReuseIdentifier: "DescriptionTableViewCell")
        
        //setup the label cell which is used for the dayreco text
        let labelNibFile = UINib(nibName: "LabelTableViewCell", bundle: nil)
        tableView.registerNib(labelNibFile, forCellReuseIdentifier: "LabelTableViewCell")
    
        //set up location nib file
        let locationNibFile = UINib(nibName: "LocationDescriptionTableViewCell", bundle: nil)
        tableView.registerNib(locationNibFile, forCellReuseIdentifier: "LocationDescriptionTableViewCell")
        
        //setup restaurant nib file
        let restaurauntNibFile = UINib(nibName: "RestaurantDetailTableViewCell", bundle: nil)
        tableView.registerNib(restaurauntNibFile, forCellReuseIdentifier: "RestaurantDetailTableViewCell")
        
        //setup user nib file
        let userNibFIle = UINib(nibName: "UserTableViewCell", bundle: nil)
        tableView.registerNib(userNibFIle, forCellReuseIdentifier: "UserTableViewCell")
        
        //setup header nib file
        let headerNibFile = UINib(nibName: "HeaderTableViewCell", bundle: nil)
        tableView.registerNib(headerNibFile, forCellReuseIdentifier: "HeaderTableViewCell")
        
        //setup rating nib file
        let ratingNibFile = UINib(nibName: "RatingTableViewCell", bundle: nil)
        tableView.registerNib(ratingNibFile, forCellReuseIdentifier: "RatingTableViewCell")
        
        
        //Used to automatically resize the cells
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
    }
    
    
    
    
    //MARK: - IBActions
    
    //Displays a new view controller.  Pass all location and restaurant information to the new view controller
    @IBAction func goToMapView(sender: AnyObject) {
        
        //get an instance of the VC to push to and set its local variables
        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MapLocationsViewController") as! MapLocationsViewController
        destinationVC.locationDetails = locationDetails
        destinationVC.RestaurantDetails = RestaurantDetails
        destinationVC.locationData = locationData
        destinationVC.restaurantData = restaurantData
        destinationVC.city = city
        //push to the new view controller
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    //Clicking on the back icon will dismiss the current view controller
    @IBAction func goBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    //tableview method to determine the height for the cells in the tableView.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 1) || (indexPath.section == 2) || (indexPath.section == sectionHeaders.count - 1) {
            return UITableViewAutomaticDimension
        } else if indexPath.section == 0 {
            return 70
        } else {
            return 80
        }
    }
    
    //return the number of sections int het ableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    //Determine how many rows are in each section.  Dependant location/restaurant count
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            case 3:
                //If there is no location data, restaurant data will be shown instead
                if locationData.count == 0 {
                    return restaurantData.count
                }
                return locationData.count
            
            //if location data is 0, show the yelp page.  restaurant data will be shown in the above section.
            case 4:
                if locationData.count == 0 {
                    return 1
                }
                return restaurantData.count
            
            default:
                return 1
        }
    }
    
    //Determine what is shown for each cell at the index path
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Switch what to show based on which section
        switch indexPath.section {
            //section for the first cell displays user information
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("UserTableViewCell", forIndexPath: indexPath) as! UserTableViewCell
            let userData = getUserData()
            //display the name, picture, and how many reviews the user has
            cell.nameLabel.text = userData.0
            if userData.1 != "" {
                let data = NSData(contentsOfURL: NSURL(string: userData.1)!)
                cell.userImage.image = UIImage(data: data!)
            }
            let recs = database.getAllRecosFromUser(recommendation.userId)
            let recCount = recs.count
            cell.reviewsLabel.text = "\(recCount) Reviews"
            
            return cell
            
            //section that shows the description of the rec
        case 1:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("DescriptionTableViewCell", forIndexPath: indexPath) as! DescriptionTableViewCell
            cell.descriptionLabel?.text = recommendation.shortDescription
            return cell
            
            //section that shows the main city recommendation
        case 2:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("LabelTableViewCell", forIndexPath: indexPath) as! LabelTableViewCell
            //set the cell's text label to that of the recommendation
            cell.recoTextLabel?.text = recommendation.dayPlan
            return cell
            
            //Display all the location data.  If there is no location data, present the restaurant data
        case 3:
            if !locationDataEmpty() {
                let cell = tableView.dequeueReusableCellWithIdentifier("LocationDescriptionTableViewCell", forIndexPath: indexPath) as! LocationDescriptionTableViewCell
                //display the name, image, and type of the location object
                cell.locationNameLabel.text = locationDetails[indexPath.row]["name"] as? String
                let image = UIImage(data: locationDetails[indexPath.row]["image"] as! NSData)
                cell.locationImgView.image = image
                cell.locationTypeLabel.text = locationDetails[indexPath.row]["type"] as? String
                
                
                //get the rating of the restaurant and break it into
                let rating = locationDetails[indexPath.row]["rating"] as! String
                let ratingFloat = Float(rating)
                let remainder = ratingFloat! % 1
                let baseRating = Int(ratingFloat!)
                
                //set the rating values to the cell
                cell.ratingLabel.text = rating
                cell.baseRating = baseRating
                cell.ratingRemainder = remainder
                cell.setImages()
                
                
                return cell
                
                
            } else {
                //Display restaurant data same as above
                let cell = tableView.dequeueReusableCellWithIdentifier("RestaurantDetailTableViewCell", forIndexPath: indexPath) as! RestaurantDetailTableViewCell
                
                //set the name and type variables
                cell.nameLabel.text = RestaurantDetails[indexPath.row]["name"] as? String
                cell.typeLabel.text = RestaurantDetails[indexPath.row]["type"] as? String
                
                //determine the price and convert it into $$$$ strng
                var priceString = ""
                let priceInt = RestaurantDetails[indexPath.row]["price"] as! Int
                for _ in 0..<priceInt {
                    priceString += "$"
                }
                
                //get the rating of the restaurant and break it into
                let rating = RestaurantDetails[indexPath.row]["rating"] as! String
                let ratingFloat = Float(rating)
                let remainder = ratingFloat! % 1
                let baseRating = Int(ratingFloat!)
                
                //set the rating values to the cell
                cell.baseRating = baseRating
                cell.ratingRemainder = remainder
                cell.setImages()
                
                //set the price and rating labels to the cell
                cell.priceRatingLabel.text = rating
                cell.priceLabel.text = priceString
                
                //set the restaurant image to the cell
                cell.imgView.image = UIImage(data: RestaurantDetails[indexPath.row]["image"] as! NSData)
                return cell
                
            }
            
            
            
            
        case 4:
            //Display the restaurant data.  If there is no restaurant data, display the ratings cell instead.
            if locationDetails.count != 0 && RestaurantDetails.count != 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("RestaurantDetailTableViewCell", forIndexPath: indexPath) as! RestaurantDetailTableViewCell
                
                //set the name and type variables
                cell.nameLabel.text = RestaurantDetails[indexPath.row]["name"] as? String
                cell.typeLabel.text = RestaurantDetails[indexPath.row]["type"] as? String
                
                //determine the price and convert it into $$$$ strng
                var priceString = ""
                let priceInt = RestaurantDetails[indexPath.row]["price"] as! Int
                for _ in 0..<priceInt {
                    priceString += "$"
                }
                
                //get the rating of the restaurant and break it into
                let rating = RestaurantDetails[indexPath.row]["rating"] as! String
                let ratingFloat = Float(rating)
                let remainder = ratingFloat! % 1
                let baseRating = Int(ratingFloat!)
                
                //set the rating values to the cell
                cell.baseRating = baseRating
                cell.ratingRemainder = remainder
                
                //set the price and rating labels to the cell
                cell.priceRatingLabel.text = rating
                cell.priceLabel.text = priceString
                cell.setImages()
                
                //set the restaurant image to the cell
                cell.imgView.image = UIImage(data: RestaurantDetails[indexPath.row]["image"] as! NSData)
                
                return cell
                
            } else {
                
                //RATING
                //Rating cell.  Show the user's current rating of this city preview
                let cell = tableView.dequeueReusableCellWithIdentifier("RatingTableViewCell", forIndexPath: indexPath) as! RatingTableViewCell
                cell.ratingDelegate = self
                
                let rating = database.getUserRecRating(recommendation.recoId, userId: User.sharedInstance.userId)
                if rating != nil {
                    //based on the rating, set the corresponding imageview
                    switch rating {
                    case 1:
                        cell.rating1Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                        cell.currentRating = 1
                    case 2:
                        cell.rating1Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                        cell.rating2Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                        cell.currentRating = 2
                    case 3:
                        cell.rating1Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                        cell.rating2Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                        cell.rating3Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                        cell.currentRating = 3
                    case 4:
                        cell.rating1Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                        cell.rating2Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                        cell.rating3Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                        cell.rating4Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                        cell.currentRating = 4
                    case 5:
                        cell.rating1Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                        cell.rating2Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                        cell.rating3Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                        cell.rating4Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                        cell.rating5Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                        cell.currentRating = 5
                    default:
                        break
                    }
                }
                return cell
            }
            
           

            
        case 5:
            //create a tableview cell
            let cell = tableView.dequeueReusableCellWithIdentifier("RatingTableViewCell", forIndexPath: indexPath) as! RatingTableViewCell
            //get the rating for the database
            //set the delegate to self
            cell.ratingDelegate = self
            let rating = database.getUserRecRating(recommendation.recoId, userId: User.sharedInstance.userId)
            if rating != nil {
                //based on rating, set the corresponding image to the imageView
                switch rating {
                case 1:
                    cell.rating1Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                case 2:
                    cell.rating1Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                    cell.rating2Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                case 3:
                    cell.rating1Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                    cell.rating2Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                    cell.rating3Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                case 4:
                    cell.rating1Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                    cell.rating2Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                    cell.rating3Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                    cell.rating4Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                case 5:
                    cell.rating1Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                    cell.rating2Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                    cell.rating3Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                    cell.rating4Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                    cell.rating5Btn.setImage(UIImage(named: "fire"), forState: .Normal)
                default:
                    break
                }
            }
            
            return cell
            
            
            
        default:
            //return some default cell
            let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath)
            return cell
        }
    }
    
    
    //How to handle when user selects on certain rows
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //The only cells that are clickable are the location and restaurant cells
        if indexPath.section == 3 {
            //Determine if the section is showing location or restaurant information
            if !locationDataEmpty() {
                
                //Create an instance of the locationdetailVC and push to the view
                let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LocationDetailViewController") as! LocationDetailViewController
                //set the location information
                destinationVC.locationDetails = locationDetails[indexPath.row]
                //locationData is used to pass the json object in order to grab the picture needed to populate the area
                destinationVC.locationData = locationData[indexPath.row]
                self.navigationController?.pushViewController(destinationVC, animated: true)
               
            } else {
                //Get an isntance of the restaurant detail VC and set the local variables then push the view controller
                let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RestaurantDetailViewController") as! RestaurantDetailViewController
                destinationVC.locationDetails = RestaurantDetails[indexPath.row]
                destinationVC.locationData = restaurantData[indexPath.row]
                self.navigationController?.pushViewController(destinationVC, animated: true)
            }
            
        }
        
        //If section path is 4, it shows restaurant information
        if indexPath.section == 4 {
            
            if locationDetails.count == 0 {
                //do nothing
                
            } else {
                //Set the isntance of the restaurant VC and set the local variables and push to the new VC
                let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RestaurantDetailViewController") as! RestaurantDetailViewController
                destinationVC.locationDetails = RestaurantDetails[indexPath.row]
                destinationVC.locationData = restaurantData[indexPath.row]
                self.navigationController?.pushViewController(destinationVC, animated: true)
            }
        }
        //Deselect the currently selected cell
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
    
    //Don't highlight certain cells
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 || indexPath.section == 1 {
            return false
        }
        return true
    }
    
    
    

    
    
    
    
    
    
    //MARK: - TableView Cell Dimensions
    
    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 3 || section == 4 || section == 5 {
            return 10
            
        } else {
            return 0
        }
        
    }
    
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        
//        if section == 3 || section == 4 {
//            let footerView = UIView(frame: CGRectMake(0,0,tableView.frame.size.width, 10))
//            return footerView
//            
//        } else {
//            let footerView = UIView(frame: CGRectMake(0,0,tableView.frame.size.width, 1))
//            return footerView
//        }
//        
//        
//    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    
    
    /****
     
     Set the section header cell.
     
     ****/
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("HeaderTableViewCell") as! HeaderTableViewCell
        
        switch section {
        case 3:
            cell.headerTextLabel.text = sectionHeaders[section]
//            let headerView = UIView(frame: CGRectMake(0, cell.frame.size.height, tableView.frame.size.width, 2))
//            headerView.backgroundColor = UIColor.blackColor()
//            cell.addSubview(headerView)
            //            let bottomPixelView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 2))
            //            bottomPixelView.backgroundColor = UIColor.blackColor()
            //
            //            footerView.addSubview(bottomPixelView)
            //            return footerView
            
        case 4:
            cell.headerTextLabel.text = sectionHeaders[section]
        case 5:
            cell.headerTextLabel.text = sectionHeaders[section]
            
        default:
            cell.headerTextLabel.text = ""
        }
        
        return cell
    }
    
    
    
    
    //Determine if there is any location data.  Count if the array of details if empty or not.  return boolean
    func locationDataEmpty () -> Bool {
        if locationDetails.count == 0 {
            return true
        }
        return false
    }
    
    //Rating Change protocol method
    func changeRating(rating: Int, changed: Bool) {
        editRating = changed
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
 
        let sectioncount = sectionHeaders.count
        let indexPath = NSIndexPath(forRow: 0, inSection: sectioncount-1)
        
        if editRating {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! RatingTableViewCell
            let rating = cell.currentRating
            
            if rating != 0 {
                
                let currentRating = database.getUserRecRating(recommendation.recoId, userId: User.sharedInstance.userId)
                if currentRating == nil {
                    database.addRating(recommendation.recoId, rating: rating, userID: User.sharedInstance.userId)
                } else {
                    //update the rating
                }
            }
        }
        
    }
    
    
    
}
