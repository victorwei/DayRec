//
//  GetCityAdapter.swift
//  DayReco
//
//  Created by iOS on 9/29/16.
//  Copyright © 2016 VictorW. All rights reserved.
//

import UIKit
import CoreLocation

class GetCityAdapter: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    weak var getCityProtocolDelegate: getCityProtocol!
    
    
    //function for request to get user's location
    func getUserLocation() {
        //request authorization for CLLocations.
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        //If the location services are enabled, set the CLLocationManager delegate to self and request the location
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            //locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }
    }
    
    
    //MARK: - CLLoctionManager Delegate Methods
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //NSLog("Update to current location")
        //Grab the curent location and set the latitude/longitude values 
        let currentLocation: CLLocation! = locations.first
        //If the current location is not nil, execute the getCurrentCity() function to find out the city based on the CLLocation coordinates
        if (currentLocation != nil){
            latitude = currentLocation.coordinate.latitude
            longitude = currentLocation.coordinate.longitude
            getCurrentCity()
        }
    }
    
    //CLLocationManager Delegate method when location manager fails.  Print the error message out
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Failed to find the user's location : \(error.localizedDescription)")
    }
    
    
    //Helper function used to determine the city the user is currently located in
    func getCurrentCity() {
        //create a CLLocation from the latitude/longitude values
        let location = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
        //user reverse geocode to determine the city near the user
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            //print(location)
            // error handling
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            //make sure results are there
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                let city = pm.locality! as String
                //protocol delegate function used to return the city to the VC that conforms to the protocol
                if self.getCityProtocolDelegate != nil {
                    self.getCityProtocolDelegate.returnCity(city)
                }
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
    }

}


//protocol to return the city as a string to requesting function
protocol getCityProtocol: NSObjectProtocol {
    func returnCity(city: String)
}
