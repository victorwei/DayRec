//
//  AddRecoViewController.swift
//  DayReco
//
//  Created by Victor Wei on 9/29/16.
//  Copyright © 2016 VictorW. All rights reserved.
//

import UIKit
import GoogleMaps

class AddRecoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, AddLocations {

    
    //MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityLabel: UILabel!
    
    var sectionHeaders: [String]!
    
    var cityName: String!
    var category: String = ""
    var writeRecoText = ""
    
    var locationsArray: [NSDictionary] = []
    var currentReco: Reco!
    var city: City!
    var googleMarkers : [GMSMarker] = []
    
    //variables used to hold textvalues
    var briefDescription = ""
    var locations: [Int:String] = [:]
    var restaurants: [Int:String] = [:]
    
    var rowBeingEditted: Int? = nil
    var database = sqlDB()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the navigation title
        self.title = "Write A Plan"
        cityLabel.text = cityName
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        
        
        //Create City object based on current city
        let cityLocation = GetLocationInfoAdapter(city: cityName)
        cityLocation.getCityLocation { (result, latitude, longitude) in
            if result {
                self.city = City(name: self.cityName, lat: latitude, lng: longitude)
            }
        }
        
        //set the section headers
        sectionHeaders = ["Description", "Category", "Plan Itinerary", "Destinations"]
        
        //set up tableView
        setupTableView()
    }
    
    
    //Protocol method to get map location data
    func getLocationsFromController (locations: [NSDictionary], markers: [GMSMarker], city: City) {
        self.locationsArray = locations
        self.googleMarkers = markers
        tableView.reloadData()
    }
    
    
    
    //Setup the tableView.  set up nib files and register the nibs for the tableview
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //nibFile used for Description section, as well as new location/restaurants when added
        let defaultNibFile = UINib(nibName: "TextEditTableViewCell", bundle: nil)
        //nibFile used to display Recommendation text
        let recoTextNibFile = UINib(nibName: "LabelTableViewCell", bundle: nil)
        //nibFile used for all Button cells.  Used to for clicking action
        let buttonNibFile = UINib(nibName: "ButtonTableViewCell", bundle: nil)
        //nibFIle used for section Headers
        let customHeaderNibFile = UINib(nibName: "CustomHeaderTableViewCell", bundle: nil)
        
        
        let mapNibleFile = UINib(nibName: "GoogleMapTableViewCell", bundle: nil)
        
        //register the nibs
        tableView.registerNib(defaultNibFile, forCellReuseIdentifier: "TextEditTableViewCell")
        tableView.registerNib(recoTextNibFile, forCellReuseIdentifier: "LabelTableViewCell")
        tableView.registerNib(customHeaderNibFile, forCellReuseIdentifier: "CustomHeaderTableViewCell")
        tableView.registerNib(buttonNibFile, forCellReuseIdentifier: "ButtonTableViewCell")
        tableView.registerNib(mapNibleFile, forCellReuseIdentifier: "GoogleMapTableViewCell")
        
        //tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //MARK: - TableView Delegate and DataSource methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    //Return number of rows based on section on whether user has filled out information
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            case 0:
                return 1
            case 1:
                return 1
            case 2:
                if writeRecoText == "" {
                    return 1
                } else {
                    return 2
                }
            case 3:
                if locationsArray.count == 0 {
                    return 1
                } else {
                    return 2
            }
            default:
                return 1
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            //A short description of the recommendation
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier("TextEditTableViewCell", forIndexPath: indexPath) as! TextEditTableViewCell
                //cell.defaultTextField.text = ""  //in case cells are re-used, this will clear the old value
                cell.defaultTextField.tag = indexPath.row
                cell.defaultTextField.delegate = self
                cell.defaultTextField.placeholder = "Example: For nature lovers!"
                return cell
            
            //How to categorize the recommendation
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("ButtonTableViewCell", forIndexPath: indexPath) as! ButtonTableViewCell
                cell.buttonLabel!.text = "- Category -"
                //If user hasn't chosen any category, use the default category title.  Else use category chosen
                if category != "" {
                    cell.buttonLabel!.text = category
                }
                return cell
            
            //The day plan recommendation that the user writes.
            case 2:
                //if the user has not clicked the add reco cell and added some text, only display 1 cell which acts as a button.
                if writeRecoText == "" {
                    let cell = tableView.dequeueReusableCellWithIdentifier("ButtonTableViewCell", forIndexPath: indexPath) as! ButtonTableViewCell
                    cell.buttonLabel!.text = "Write a day plan"
                    return cell
                } else {
                    //User has written some text.  Show two cells.  One with button to add the day plan, the other to display what the user wrote.
                    //show the same button cell for the first cell
                    if indexPath.row == 0 {
                        let cell = tableView.dequeueReusableCellWithIdentifier("ButtonTableViewCell", forIndexPath: indexPath) as! ButtonTableViewCell
                        cell.buttonLabel!.text = "Write a day plan"
                        return cell
                        //display what the user wrote in its own cell
                    } else {
                        let cell = tableView.dequeueReusableCellWithIdentifier("LabelTableViewCell", forIndexPath: indexPath) as! LabelTableViewCell
                        cell.recoTextLabel.text = writeRecoText
                        cell.recoTextLabel.numberOfLines = 0
                        cell.recoTextLabel.sizeToFit()
                        return cell
                    }
                }
                
            
            //The locations that the user recommends
            case 3:
                //Button cell to add a locations for the rec
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCellWithIdentifier("ButtonTableViewCell", forIndexPath: indexPath) as! ButtonTableViewCell
                    cell.buttonLabel!.text = "Add Locations"
                    return cell
                } else {
                    
                    //set up the map view of the cell
                    let cell = tableView.dequeueReusableCellWithIdentifier("GoogleMapTableViewCell", forIndexPath: indexPath) as! GoogleMapTableViewCell
                    //Set the city and markes to display on the cell
                    cell.city = city
                    cell.markerArray = googleMarkers
                    cell.updateView()
                    return cell
                }
            
            default:
                //some default case
                let cell = tableView.dequeueReusableCellWithIdentifier("TextEditTableViewCell", forIndexPath: indexPath) as! TextEditTableViewCell
                cell.defaultTextField.placeholder = "Example: For nature lovers!"
                return cell
        }
    }
    
    
    
    /****
     
     How to handle user clicking on certain cells.  Perform segues to other view controllers based on which cell is selected
     
     ****/
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        //Choose the category
        case 1:
            performSegueWithIdentifier("addCategorySegue", sender: self)
        
        //Write the rec segue
        case 2:
            if indexPath.row == 0 {
                performSegueWithIdentifier("writeRecoSegue", sender: self)
            }
        
        //bring up new controller where user can add locations
        case 3:
            if indexPath.row == 0 {
                let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AddLocationViewController") as! AddLocationViewController
                let destinationNC = UINavigationController(rootViewController: destinationVC)
                //set the destination VC's delegate to self.  Pass the city data to the VC
                destinationVC.city = city
                destinationVC.delegate = self
                presentViewController(destinationNC, animated: true, completion: nil)
            }
        default:
            break
        }
        //Deselect the row at indexpath
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    
    /****
     
     Set the section header cell.
     
     ****/
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomHeaderTableViewCell") as! CustomHeaderTableViewCell
     
        switch section {
            case 0:
                cell.headerTextLabel.text = sectionHeaders[0]
            case 1:
                cell.headerTextLabel.text = sectionHeaders[1]
            case 2:
                cell.headerTextLabel.text = sectionHeaders[2]
            case 3:
                cell.headerTextLabel.text = sectionHeaders[3]
            default:
                cell.headerTextLabel.text = "Other"
        }
        
        return cell
    }
    
    
    
    
    
    
    
    //MARK: - TableView Cell Dimensions
    
    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return UITableViewAutomaticDimension
        } else if indexPath.section == 3{
            if indexPath.row == 1 {
                return view.frame.width
            } else {
                return 45
            }
        } else {
            return 45
        }
    }
    
    //TextField delegate method.  Used to determine if user is a textfield's first responder
    func textFieldDidBeginEditing(textField: UITextField) {
        rowBeingEditted = textField.tag
    }
    
    
    //MARK: - TextField Delegate
    //Used to grab the value of the textfield after the user has finished typing
    func textFieldDidEndEditing(textField: UITextField) {
        let tag = textField.tag
        //grab the textField for the description textfield
        if tag == 0 {
            briefDescription = textField.text!
        }
        rowBeingEditted = nil
    }
    
    
    
    
    
    //MARK: - IBActions
    //IBActions by the navigation bar button items
    
    @IBAction func cancelRecoAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveRecoAction(sender: UIBarButtonItem) {
        
        //Used to check if the user is currently typing in the text edit.  If so, tell the textfield to complete editting which will call the textfieldidEndEditting field
        if let row = rowBeingEditted {
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! TextEditTableViewCell
            cell.defaultTextField.resignFirstResponder()
        }
        
        if areSectionsFilledOut() {
            
            saveToSql()
            dismissViewControllerAnimated(true, completion: nil)
            
        } else {
            //user has not filled out all the fields
            displayAlert()
        }
        
    }
    
    
    
    //Save the fields to the sql database
    func saveToSql() {
        
        //add the rec to the database
        database.addReco(User.sharedInstance.userId, category: category, description: briefDescription, reco: writeRecoText, city: cityName)
        //get the rec id from the record just entered
        let recoId = database.getRecoId(User.sharedInstance.userId, description: briefDescription, reco: writeRecoText, city: cityName)
        
        //Go through each location in the array and sort it as either a location or a restaurant/food/drink area.  Add the location to the appropriate database based on what type of location it is.
        for index in 0..<locationsArray.count {
            var isFoodDrink = false
            if let types = locationsArray[index]["types"] as? NSArray {
                //check the type of the location to determine if it is of food/drink category.
                for singletype in types {
                    let type = singletype as! String
                    if type ==  "food" || type ==  "bakery" || type ==  "cafe" || type ==  "restaurant" || type ==  "meal_delivery" || type ==  "meal_takeout" {
                        isFoodDrink = true
                        break
                    }
                } //end of for type
            } // end of if
            
            let placeId = locationsArray[index]["place_id"] as! String
            let placeName = locationsArray[index]["name"] as! String
            
            if isFoodDrink {
                database.addRestaurant(recoId, restaurant: placeName, placeId: placeId, city: cityName)
            } else {
                database.addLocation(recoId, location: placeName, placeId: placeId, city: cityName)
            }
        } // end of for locationindex
        
    }

    

    /****
     
     Display an alert if sections are not filled out.  Alert the user to fill out all fields.
     
     ****/
    func displayAlert () {
        //Create UIAlertController with the title and message
        let alertController = UIAlertController(title: "Fields Not Filled Out", message: "Please fill out all the fields", preferredStyle: .Alert)
        //Define the button action and add it to the alert controller
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(okAction)
        //Show the alert
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    /****
     
    Function to determine if user has filled out all sections.  Return false if any section is empty.
    
     ****/
    func areSectionsFilledOut() -> Bool {
        //check if the description/category/writeRecoText is empty
        if briefDescription == "" || category == "" || writeRecoText == ""{
            return false
        }
        //check if user has added any locations
        if locationsArray.count == 0 {
            return false
        }
        return true
    }
    

    
    //Unwind segue actions.  Grab information from the segue that is unwound from
    @IBAction func performUnwindSegue(segue: UIStoryboardSegue){
        if segue.identifier == "unwindToAddRecoVC" {
            let previousVC = segue.sourceViewController as! CategoryViewController
            category = previousVC.categorySelected
            tableView.reloadData()
        }
        
        
        if segue.identifier == "unwindWriteRecoSegue" {
            let previousVC = segue.sourceViewController as! WriteRecoViewController
            writeRecoText = previousVC.recoText
            tableView.reloadData()
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
