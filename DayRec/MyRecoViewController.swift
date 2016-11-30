//
//  MyRecoViewController.swift
//  DayReco
//
//  Created by Victor Wei on 9/30/16.
//  Copyright © 2016 VictorW. All rights reserved.
//

import UIKit

class MyRecoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: - Properties
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var database: sqlDB!
    var recArray: [Reco] = []
    var locationAdapter : GetLocationInfoAdapter!
    var activityIndicator: UIActivityIndicatorView!
    var currentRecoCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //create the database instance
        database = sqlDB()
        locationAdapter = GetLocationInfoAdapter(city: "San Francisco")
        self.view.backgroundColor = UIColor(netHex: 0x7375d6)
        
        
        setupTableView()
        navigationItem.title = "What's The Plan"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Georgia-BoldItalic", size: 17)!]
        
    }
    
    //update the recos view
    override func viewDidAppear(animated: Bool) {
        if currentRecoCount == database.getAllRecosFromUser(User.sharedInstance.userId).count {
            //do nothing
            
        } else {
            getMyRecos()
        }
        
    }
   
    
    func setupTableView () {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        
        let usersNibFile = UINib(nibName: "UserRecoTableViewCell", bundle: nil)
        tableView.registerNib(usersNibFile, forCellReuseIdentifier: "UserRecoTableViewCell")
        tableView.rowHeight = 80
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Helper function to update tableView with information.  Retrieves all recs associated with the user's id.
    func getMyRecos() {
        //Set the activity indicator as user retrieves data
        activityIndicator = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        self.view.backgroundColor = UIColor(netHex: 0x7375d6)
        
        //wipe the rec array to an empty state
        recArray = []
        //get all recos associated with the userId as an NSMutableArray
        let recos = database.getAllRecosFromUser(User.sharedInstance.userId)
        //Go through each recos object and get information as needed
        for index in 0..<recos.count {
            let recId = recos[index][0] as! Int
            let userId = recos[index][1] as! Int
            let category = recos[index][2] as! String
            let recDescription = recos[index][3] as! String
            let rec = recos[index][4] as! String
            let city = recos[index][5] as! String
            //Create a reco object based on the results
            let currentRec = Reco(description: recDescription, category: category, dayPlan: rec, city: city, recoId: recId, userId: userId)
            
            var locationsArray: [NSDictionary] = []
            var restaurantsArray: [NSDictionary] = []
            
            
            //get location data based on recoId
            let locations = database.getLocationsForReco(recId)
            
            for location in locations {
                let placeId = location[1] as! String
                locationAdapter.getLocationDetailFromPlaceId(placeId, completion: { (result, data) in
                    
                    locationsArray.append(data)
                    currentRec.locationArray = locationsArray
                    //self.AllLocations[index] = locationsArray
                    
                })
            }
            
            
            //get restaurant data
            let restaurants = database.getRestaurantsForReco(recId)
            for restaurant in restaurants {
                let placeId = restaurant[1] as! String
                locationAdapter.getLocationDetailFromPlaceId(placeId, completion: { (result, data) in
                    restaurantsArray.append(data)
                    currentRec.restaurantArray = restaurantsArray
                })
            }
            
            
            recArray.append(currentRec)
        }
        tableView.reloadData()
        
        //stop the activity indicator as user gets data
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()

    }
    
  
    
    //Display sections in the table
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //return the amount of recs retrieved
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recArray.count
    }
    //return what to display for each cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserRecoTableViewCell", forIndexPath: indexPath) as! UserRecoTableViewCell
        //Display which city is shown and the description of the reco
        cell.cityLabel.text = recArray[indexPath.row].city
        cell.recoLabel.text = recArray[indexPath.row].shortDescription
        
        //update the pictre of the city rec with a random picture of the city
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.locationAdapter.getSpecificCityInfo(self.recArray[indexPath.row].city, completion: { (result, placeId) in
                self.locationAdapter.getLocationDetailFromPlaceId(placeId, completion: { (result, data) in
                    let cityImage = self.locationAdapter.getPictureForLocation(60, data: data)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        cell.cityImageView.image = UIImage(data: cityImage!)
                    })
                })
            })
            
        }
        return cell
    }
    
    
    
    //if user selects a cell,display the previewRecoViewController.  pass the associating reco's information and push to the new view controller
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //create an instance of the VC to show
        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PreviewRecoViewController") as! PreviewRecoViewController
        let destinationNC = UINavigationController(rootViewController: destinationVC)
        destinationVC.recommendation = recArray[indexPath.row]
        presentViewController(destinationNC, animated: true, completion: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    
    
    
    
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "createRecoSegue"{
//            
//            let destinationVC = segue.destinationViewController as! AddRecoViewController
//            destinationVC.cityName = cityTextField.text
//        }
//    }

//    
//    //Display alert
//    func displayAlert () {
//        //Create UIAlertController with the title and message
//        let alertController = UIAlertController(title: "Field cannot be empty", message: "Please enter a city", preferredStyle: .Alert)
//        //Define the button action and add it to the alert controller
//        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
//        alertController.addAction(okAction)
//        //Show the alert
//        presentViewController(alertController, animated: true, completion: nil)
//    }
//    
    
   
   

}
