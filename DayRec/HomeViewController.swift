//
//  HomeViewController.swift
//  DayReco
//
//  Created by iOS on 9/29/16.
//  Copyright © 2016 VictorW. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class HomeViewController: UIViewController, getCityProtocol, UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: - Properties
    var cityAdapter: GetCityAdapter!
    var currentCity: String!

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var locationAdapter: GetLocationInfoAdapter!
    var database = sqlDB()
    var recArray: [Reco] = []
    var activityIndicator: UIActivityIndicatorView!
    
    var networkDown = false
    var networkManager: Reachability!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Determine if network is available.  if so, get the current city the user is located in
        if isNetworkAvailable() {
            //create an instance of GetCityAdapter and assign the delegate to seelf
            cityAdapter = GetCityAdapter()
            cityAdapter.getCityProtocolDelegate = self
            
            //create an activity indicator to display while program is retrieving results
            activityIndicator = UIActivityIndicatorView()
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            activityIndicator.startAnimating()
            self.view.addSubview(activityIndicator)
            
            //function that determine's users location and returns the city string
            cityAdapter.getUserLocation()
            //setup the tableview
            setupTableView()
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            
        } else  {
            print("network is not avialable.  Please get your connection straight")
        
        }
        
        
        
        
    }
    
    //update the tableView when view appears
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if currentCity != nil {
            updateTable()
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // reachability function to determine if network is available to connect
    func isNetworkAvailable () -> Bool {
        
        //check the reachability and get its reachability status.  if the status is unreachable, return false and set the networkDown bool to true
        networkManager = Reachability(hostName: "https://www.google.com")
        if networkManager.currentReachabilityStatus() == NotReachable {
            print ("no internet connection")
            networkDown = true
            return false
        }
        //network is reachable, return true and set the networkDown bool to false
        networkDown = false
        return true
    }
    
    
    //Helper function to setup the tableView
    func setupTableView() {
        //setup the tableView delegate and cells
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        let defaultNibFile = UINib(nibName: "CityTableViewCell", bundle: nil)
        tableView.registerNib(defaultNibFile, forCellReuseIdentifier: "CityTableViewCell")
        tableView.rowHeight = 90
    }
    
    //delegate method that grabs the user's current city location
    func returnCity(city: String) {
        
        //set the local city variable to the city
        currentCity = city
        //update the table and remove the activity indicator
        updateTable()
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    
    
    //MARK: - IBActions
    //AGO to a new view controller that allows user to add a recommendation to the current city
    @IBAction func addRecToCurrentCity(sender: AnyObject) {
        //Get an isntance of the view controller to go to and present it modally
        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AddRecoViewController") as! AddRecoViewController
        let destinationNC = UINavigationController(rootViewController: destinationVC)
        //set the destination VC's city object to the current city
        destinationVC.cityName = currentCity
        presentViewController(destinationNC, animated: true, completion: nil)
        
    }
    
    
    //Function to search for recommendations for a specific city
    @IBAction func searchForCityRec(sender: AnyObject) {
        //get the textfield text and set the current city object to the text.  Update the table based on which city
        let city = searchTextField.text
        currentCity = city
        updateTable()
    }
    
    
    
    //Helper function to update the table based on the current city
    func updateTable() {
        
        //create the LocationInfo adapter
        locationAdapter = GetLocationInfoAdapter(city: currentCity)
        //Update the text label based on the city
        dispatch_async(dispatch_get_main_queue()) {
            //self.currentCityLabel.text = "Recommendations for \(city)"
            self.searchTextField.placeholder = self.currentCity
            self.navigationItem.title = self.currentCity
        }
        //set the current recArray to be empty
        recArray = []
        //get all reco objects based on the current city
        let recos = database.getAllRecosForCity(currentCity)
        //For all results, create a Reco object and add it to the array
        for index in 0..<recos.count {
            //Get the data from the recos result and add them to a Reco object
            let recId = recos[index][0] as! Int
            let userId = recos[index][1] as! Int
            let category = recos[index][2] as! String
            let recDescription = recos[index][3] as! String
            let rec = recos[index][4] as! String
            let city = recos[index][5] as! String
            let currentRec = Reco(description: recDescription, category: category, dayPlan: rec, city: city, recoId: recId, userId: userId)
            
            var locationsArray: [NSDictionary] = []
            var restaurantsArray: [NSDictionary] = []
            
            
            //get location data based on the reco Id
            let locations = database.getLocationsForReco(recId)
            //add the locations and add it to the locationsArray
            for location in locations {
                let placeId = location[1] as! String
                //get the location detail and add the data object to the lcoations array
                locationAdapter.getLocationDetailFromPlaceId(placeId, completion: { (result, data) in
                    locationsArray.append(data)
                    currentRec.locationArray = locationsArray
                })
            }
            
            
            //get restaurant data based on the reco Id
            let restaurants = database.getRestaurantsForReco(recId)
            //get the associated restaurant objects associated with each recoId
            for restaurant in restaurants {
                let placeId = restaurant[1] as! String
                locationAdapter.getLocationDetailFromPlaceId(placeId, completion: { (result, data) in
                    restaurantsArray.append(data)
                    currentRec.restaurantArray = restaurantsArray
                })
            }
            
            //apend the reco object to the array
            recArray.append(currentRec)
        }
        //reload the table view
        tableView.reloadData()
        
    }
    @IBAction func sortResults(sender: AnyObject) {
    
    }
 
    
    //Helper function used to grab the user's information
    func getUserData (userId: Int) -> (String, String, String) {
        //Get the user data and return Strig value of first/last name, get the image of the user, and get the bio of the user
        let userdata = database.getUserDataFromId(userId)
        let firstName = userdata[1] as! String
        let lastName = userdata [2] as! String
        let lastInitial = String(lastName[lastName.startIndex])
        let name = firstName + " " + lastInitial + "."
        let image = userdata[4] as! String
        let bio = userdata[3] as! String
        return (name, image, bio)
        
    }
    
    
    
    //tableView delegate and datasource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //return the recarray count
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recArray.count
    }
    
    
    //Display the information
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CityTableViewCell", forIndexPath: indexPath) as! CityTableViewCell
        
        
        //get user data depending on which rec it is and set the cell's editables from the userdata
        let userId = recArray[indexPath.row].userId
        let userData = getUserData(userId)
        cell.userNameLabel.text = userData.0
        if userData.1 != "" {
            let data = NSData(contentsOfURL: NSURL(string: userData.1)!)
            cell.imgView.image = UIImage(data: data!)
        }
        
        //set the cell's description to the rec's description
        cell.recDescriptionLabel.text = recArray[indexPath.row].shortDescription
        
        
        //set the ratings image
        let rating = getAvgRating(recArray[indexPath.row].recoId)
        //based on rating, set the image
        if rating != 0 {
            switch rating {
            case 1:
                cell.rating1Img.image = UIImage(named: "fire")
            case 2:
                cell.rating1Img.image = UIImage(named: "fire")
                cell.rating2Img.image = UIImage(named: "fire")
            case 3:
                cell.rating1Img.image = UIImage(named: "fire")
                cell.rating2Img.image = UIImage(named: "fire")
                cell.rating3Img.image = UIImage(named: "fire")
            case 4:
                cell.rating1Img.image = UIImage(named: "fire")
                cell.rating2Img.image = UIImage(named: "fire")
                cell.rating3Img.image = UIImage(named: "fire")
                cell.rating4Img.image = UIImage(named: "fire")
            case 5:
                cell.rating1Img.image = UIImage(named: "fire")
                cell.rating2Img.image = UIImage(named: "fire")
                cell.rating3Img.image = UIImage(named: "fire")
                cell.rating4Img.image = UIImage(named: "fire")
                cell.rating5Img.image = UIImage(named: "fire")
            default:
                break
            }
        } else {
            cell.rating1Img.image = UIImage(named: "fire-empty")
            cell.rating2Img.image = UIImage(named: "fire-empty")
            cell.rating3Img.image = UIImage(named: "fire-empty")
            cell.rating4Img.image = UIImage(named: "fire-empty")
            cell.rating5Img.image = UIImage(named: "fire-empty")
        }
        return cell
    }
    
    
    //what to do when user selects a cell.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //If user selects a row, take them to a new view controller that displays the rec's data
        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PreviewRecoViewController") as! PreviewRecoViewController
        let destinationNC = UINavigationController(rootViewController: destinationVC)
        //set the destionation vc's info to the corresponding rec and present the controller
        destinationVC.recommendation = recArray[indexPath.row]
        presentViewController(destinationNC, animated: true, completion: nil)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

    }
    
    
    //Helper function to get the average rating of the rec based on user Id.  Returns an int value
    func getAvgRating(recId: Int) -> Int {
        let ratings = database.getRatingsForReco(recId)
        if ratings.count == 0 {
            return 0
        }
        var avgRating = 0
        for rating in ratings{
            let rate = rating[1] as! Int
            avgRating += rate
        }
        return avgRating / ratings.count
        
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
