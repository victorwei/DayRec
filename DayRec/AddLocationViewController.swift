//
//  AddLocationViewController.swift
//  DayReco
//
//  Created by Victor Wei on 10/6/16.
//  Copyright © 2016 VictorW. All rights reserved.
//

import UIKit

import GoogleMaps
import GooglePlaces

//Protocol to pass information from this view controller to another
protocol AddLocations: NSObjectProtocol {
    func getLocationsFromController (locations: [NSDictionary], markers: [GMSMarker], city: City)
}


class AddLocationViewController: UIViewController, UISearchBarDelegate,  GMSMapViewDelegate, LocateOnMap {
    
    
    //MARK: - Properties
    @IBOutlet weak var googleMapContainerView: UIView!
    
    var googleMapView: GMSMapView!
    var autoCompleteController: SearchResultsController!
    var resultsArray: [String] = []
    var markerArray: [GMSMarker] = []
    
    var locationsArray: [NSDictionary] = []
    var LocationManager: GetLocationInfoAdapter!
    
    weak var delegate: AddLocations!
    
    
    //local city variables
    var city: City!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //initalize the google map view and set it to the UIView's frame
        self.googleMapView = GMSMapView(frame: self.googleMapContainerView.frame)
        
        //set the map position/camera view
        let camera = GMSCameraPosition.cameraWithLatitude(city.latitude, longitude: city.longitude, zoom: 11.5)
        self.googleMapView.camera = camera
        self.view.addSubview(self.googleMapView)
        
        //Set the google map's delegate to self
        googleMapView.delegate = self
        
        //Create the Search Results Controller used for the autocomplete in the search bar and set the delegate to self
        autoCompleteController = SearchResultsController()
        autoCompleteController.city = city
        autoCompleteController.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //LocateOnMap Delegate Function
    // create a marker from the latitudelongitude and data of the selected location
    func locateWithCoordinates(latitude: Double, longitude: Double, title: String, data: NSDictionary) {
        dispatch_async(dispatch_get_main_queue()) {
            
            //create the coordinate from latitude/longitude values
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            let marker = GMSMarker(position: coordinate)
            
            //append the data to the locationArray
            self.locationsArray.append(data)
            
            //set the gogole map location/zoom
            let camera = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: 12)
            self.googleMapView.camera = camera
            marker.title = "\(title)"
            
            //Append the marker to the marker array.  Add the marker to the map
            self.markerArray.append(marker)
            marker.map = self.googleMapView
        }
    }
    

    //present the search bar when user clicks search icon
    @IBAction func searchLocationAction(sender: AnyObject) {
        let searchBar = UISearchController(searchResultsController: autoCompleteController)
        searchBar.searchBar.delegate = self
        self.presentViewController(searchBar, animated: true, completion: nil)
    }
    
    
    //dismiss the view controller and send the location data back to the previous VC
    @IBAction func goBackAction(sender: AnyObject) {
        delegate.getLocationsFromController(locationsArray, markers: markerArray, city: city)
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    //Function to create the UISearchBar
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //Create a GMPSPlaces client
        let placeClient = GMSPlacesClient()
        //set the offset of the searchable area
        let offset = 200.0/1000.0
        let cityLat = city.latitude
        let cityLng = city.longitude
        
        //set the northwest coordinate and southeast coordinate of where searches will occur
        let latMax = cityLat + offset;
        let latMin = cityLat - offset;
        let lngOffset = offset * cos(cityLat * M_PI / 200.0);
        let lngMax = cityLng + lngOffset;
        let lngMin = cityLng - lngOffset;
        //create the CLLocation from the above values
        let initialLocation = CLLocationCoordinate2D(latitude: latMax, longitude: lngMax)
        let otherLocation = CLLocationCoordinate2D(latitude: latMin, longitude: lngMin)
        
        //create the CoordinateBounds from the CLLocations. and search based the text
        let bounds = GMSCoordinateBounds(coordinate: initialLocation, coordinate: otherLocation)
        placeClient.autocompleteQuery(searchText, bounds: bounds, filter: nil) { (results, error) in
            
            //refresh the current results array
            self.resultsArray.removeAll()
            //if there are no results return nothing
            if results == nil {
                return
            }
            //for each result append it to the resutls array
            for result in results! {
                if let result = result as? GMSAutocompletePrediction {
                    self.resultsArray.append(result.attributedFullText.string)
                }
            }
            //reload the auto complete data
            self.autoCompleteController.reloadDataWithArray(self.resultsArray)
        }
    }
    
    
    //If the user long presses the info, prompt the user to delete that location
    func mapView(mapView: GMSMapView, didLongPressInfoWindowOfMarker marker: GMSMarker) {
        displayDeleteAlert(marker)
    }
    
    //Helper function to delete a marker from the map
    func displayDeleteAlert(marker: GMSMarker) {
        //Create an alert controller promprting the user if they want to delete the marker.  Create a cancel action and a delete action.
        let alertController = UIAlertController(title: "Notice", message: "Delete this location?", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { UIAlertAction in
            //Closure for if user wants to delete the marker.
            //Find the correct marker from the array and remove it from the array.  reload the map
            for index in 0..<self.markerArray.count {
                if self.markerArray[index] == marker {
                    self.markerArray[index].map = nil
                    //markerArray[index] = nil
                    self.markerArray.removeAtIndex(index)
                    self.locationsArray.removeAtIndex(index)
                    break
                }
            }
            self.googleMapView.clear()
            
            for index in 0..<self.markerArray.count {
                self.markerArray[index].map = self.googleMapView
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        //Show the alert
        presentViewController(alertController, animated: true, completion: nil)
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
