//
//  MapLocationsViewController.swift
//  DayRec
//
//  Created by Victor Wei on 10/10/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapLocationsViewController: UIViewController, GMSMapViewDelegate {

    //MARK: - Properties
    @IBOutlet weak var googleMapContainer: UIView!
    var googleMapView: GMSMapView!
    var city: City!
    var locationDetails : [Dictionary<String, AnyObject>]!
    var RestaurantDetails : [Dictionary <String, AnyObject>]!
    
    var locationData: [NSDictionary]!
    var restaurantData: [NSDictionary]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Setup the google MapView
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //setup the map and add markers to the map
        setupGoogleMapView()
        addMarkersToMap()
        //Set the navigation title and text color
        navigationItem.title = "Locations"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    //Setup the google map view
    func setupGoogleMapView() {
        //initalize the google map view and set it to the UIView's frame
        self.googleMapView = GMSMapView(frame: self.googleMapContainer.frame)
        
        //set the map position/camera view
        let camera = GMSCameraPosition.cameraWithLatitude(city.latitude, longitude: city.longitude, zoom: 11.5)
        self.googleMapView.camera = camera
        self.view.addSubview(self.googleMapView)
        googleMapView.delegate = self
        
    }
    
    //Add markers to the google map
    func addMarkersToMap() {
        
        //Add locations as markers to the map
        for index in 0..<locationDetails.count {
            //get the latitude/longitude details of the location
            let latitude = locationDetails[index]["latitude"] as! Double
            let longitude = locationDetails[index]["longitude"] as! Double
            //create a CLLocation from lat/lng values
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            //Add the marker at the location and set the title of the marker
            let marker = GMSMarker(position: coordinate)
            let title = locationDetails[index]["name"] as! String
            marker.title = title
            marker.map = self.googleMapView
            //Add a tag so we can reference which marker was selected later
            marker.userData = index
        }
        
        
        //Add restaurants as markers to the map.  Do the same as locations, but just for restaurants
        for index in 0..<RestaurantDetails.count {
            let latitude = RestaurantDetails[index]["latitude"] as! Double
            let longitude = RestaurantDetails[index]["longitude"] as! Double
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            let marker = GMSMarker(position: coordinate)
            let title = RestaurantDetails[index]["name"] as! String
            marker.title = title
            marker.map = self.googleMapView
            //Add a tag so we can reference which marker was selected later
            marker.userData = index + 20
        }
    }
    
    
    
    
    
    //If user taps on the info window of the marker, take them to the correspodning VC that gives a more detailed view.
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        //Find out which marker was tagged by the tag number.
        let markerTag = marker.userData as! Int
        //Find the corresponding location information based on the tag number
        if markerTag < 20 {
            //create an instance of the view controller and push the view.
            let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LocationDetailViewController") as! LocationDetailViewController
            destinationVC.locationDetails = locationDetails[markerTag]
            //locationData is used to pass the json object in order to grab the picture needed to populate the area
            destinationVC.locationData = locationData[markerTag]
            
            self.navigationController?.pushViewController(destinationVC, animated: true)
            
            //If tag number is over  20, means it iis a restaurant location
        } else {
            //create instance of the restaurant VC and push it
            let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RestaurantDetailViewController") as! RestaurantDetailViewController
            destinationVC.locationDetails = RestaurantDetails[markerTag - 20]
            //locationData is used to pass the json object in order to grab the picture needed to populate the area
            destinationVC.locationData = restaurantData[markerTag - 20]
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
