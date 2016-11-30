//
//  GetLocationInfoAdapter.swift
//  DayReco
//
//  Created by Victor Wei on 10/2/16.
//  Copyright © 2016 VictorW. All rights reserved.
//

import UIKit

class GetLocationInfoAdapter: NSObject {
    
    //MARK: - Properties
    var city: String
    let baseURLforLocation = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location="
    let baseURLforCity = "https://maps.googleapis.com/maps/api/geocode/json?"
    let baseURLforPhotos = "https://maps.googleapis.com/maps/api/place/photo?maxwidth="
    let baseURLforDetails = "https://maps.googleapis.com/maps/api/place/details/json?placeid="
    let googleAPIkey = "AIzaSyD9otanbg6qP9DvIxWfLExAfCg1q8wQJxo"
    
    
    //  OLD  let googleAPIkey = "AIzaSyDe1KKF2WEJoIpU_tS35KmTb82MzXGgjSQ"
    //let googleAPIkey = "AIzaSyDtNXaPCI3CupB0Ekgr2L-b4wNqvrSSm9A"
    

    init(city: String){
        self.city = city
    }
    
    
    //Get the latitude/longitude values based on the city string name
    func getCityLocation( completion: (result: Bool, latitude: Double, longitude: Double)->()) {
        //prepare the city string to be used within html format
        let cityString = city.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        //set the url in a NSURL format
        let url = NSURL(string: "\(baseURLforCity)address=\(cityString)&key=\(googleAPIkey)")
        //get the data of the url in a NSData format
        let data = NSData(contentsOfURL: url!)
        //get the json data as a NSDictionary object
        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
        //parse the json result to grab the latitude and longitude values
        if let result = json["results"] as? NSArray {
            if let geometry = result[0]["geometry"] as? NSDictionary {
                if let location = geometry["location"] as? NSDictionary {
                    //get the latitude and longitude values
                    let latitudeVal = location["lat"] as! Double
                    let longitudeVal = location["lng"] as! Double
                    //send the values to the completion closure
                    completion(result: true, latitude: latitudeVal, longitude: longitudeVal)
                }
            }
        }
    }
    
    
    //Returns the placeId of a city in order to get more detailed information.  Used with other function that requires placeId string.
    func getSpecificCityInfo(city: String, completion: (result: Bool, placeId: String)->()) {
        //prepare the city string to be used within html format
        let cityString = city.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        //set the url in a NSURL format
        let url = NSURL(string: "\(baseURLforCity)address=\(cityString)&key=\(googleAPIkey)")
        //get the data of the url in a NSData format
        let data = NSData(contentsOfURL: url!)
        //get the json data as a NSDictionary object
        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
        //parse the json result to grab the latitude and longitude values
        if let result = json["results"] as? NSArray {
            if let placeId = result[0]["place_id"] as? String {
                completion(result: true, placeId: placeId)
            }
            
        }
    }
    
    
    /**********
 
     Get Location Functions.
     
     Functions are used to grab a location's coordinate, information, picture, type, and map info
 
    **********/
    
    //Get json result of a location based on the name of the venue within a city coordinates.  Completion block returns whether grabbing the results was successful or the json data as a NSDictionary.
    func getLocationInfo (latitude: Double, longitude: Double, location: String, completion: (result: Bool, data: NSDictionary)->()) {
        //get the url used for NSData
        let locationString = location.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        let urlString = "\(baseURLforLocation)\(latitude),\(longitude)&radius=10000&name=\(locationString)&key=\(googleAPIkey)"
        let url = NSURL(string: "\(baseURLforLocation)\(latitude),\(longitude)&radius=18000&name=\(locationString)&key=\(googleAPIkey)")
        //get the data from the url string above
        let data = NSData(contentsOfURL: url!)
        //get the json data from the NSData as an NSDictionary object
        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
        //parse the json result to grab the desired results
        if let result = json["results"] as? NSArray {
            //the first result (hypothetically) should be the same as our search query (locationString).  Make sure the result we are grabbing is for the correct location
            let locationResult = result[0] as? NSDictionary
            //send the closure that we have successfully grabbed the data and send it within the data object
            completion(result: true, data: locationResult!)
        }
    }
    
    
    //The results we are getting shoul come in the form of a NSDictionary object.  Return the location coordinates as Double values.
    func getLocationCoordinates(data: NSDictionary) -> (Double, Double)?{
        //Parse the NSDictionary result to get the location value
        if let geometry = data["geometry"] as? NSDictionary {
            //parse the geometry result to get the location value
            if let location = geometry["location"] as? NSDictionary {
                //get the latitude/longitude values and return them
                let latitude = location["lat"] as! Double
                let longitude = location["lng"] as! Double
                return (latitude, longitude)
            }
        }
        //Wasn't able to parse the data dictionary so return nil
        return nil
    }
    
    //Takes in the json data for a location and returns the NSData of a picture.  Input variables include the width of the picture.
    func getPictureForLocation(width: Int, data: NSDictionary) -> NSData? {
        //Get the photo reference as a String value
        
//        guard let photos = data["photos"]![0] as? NSDictionary  else {
//            return nil
//        }
//        let photoReference = photos["photo_reference"] as! String
//        //get the new URL used from the photorefrence to get the picture
//        let URL = NSURL(string: "\(baseURLforPhotos)\(width)&photoreference=\(photoReference)&key=\(googleAPIkey)")
//        let urlstring = "\(baseURLforPhotos)\(width)&photoreference=\(photoReference)&key=\(googleAPIkey)"
//        if let data = NSData(contentsOfURL: URL!){
//            return data
//        } else {
//            return nil
//        }
//        
        
        
        
        if let photos = data["photos"]![0] as? NSDictionary {
            let photoReference = photos["photo_reference"] as! String
            //get the new URL used from the photorefrence to get the picture
            let URL = NSURL(string: "\(baseURLforPhotos)\(width)&photoreference=\(photoReference)&key=\(googleAPIkey)")
            let urlstring = "\(baseURLforPhotos)\(width)&photoreference=\(photoReference)&key=\(googleAPIkey)"
            if let data = NSData(contentsOfURL: URL!){
                return data
            } else {
                return nil
            }
        } else {
            return nil
        }
        
        
        //return NSData(contentsOfURL: URL!)!
    }
    
    
    //Returns a random picture from the json data result
    func getRandomPicture(width: Int, data: NSDictionary) -> NSData? {
        //Get the photo reference as a String value
        let photoArray = data["photos"] as! NSArray
        //determine how many picture objects are in the NSDictionary and grab a random object.
        let randomCount = Int(arc4random_uniform(UInt32(photoArray.count)))
        //get the reference of the photo as a string object
        let photos = photoArray[randomCount] as! NSDictionary
        let photoReference = photos["photo_reference"] as! String
        //set the url with the photoreference to grab the picture as a NSURL object
        let URL = NSURL(string: "\(baseURLforPhotos)\(width)&photoreference=\(photoReference)&key=\(googleAPIkey)")
        let urlstring = "\(baseURLforPhotos)\(width)&photoreference=\(photoReference)&key=\(googleAPIkey)"
        if let data = NSData(contentsOfURL: URL!){
            return data
        } else {
            return nil
        }
        //return NSData(contentsOfURL: URL!)!
    }

    
    //Get the detailed location information based on the place id.  Get a more detailed json result based from the place ID.  Returns the json result as a NSDictionary object.
    func getLocationDetailFromPlaceId(placeId: String, completion: (result: Bool, data: NSDictionary)->()) {
        //set the default url to grab the location data.
        let url = NSURL(string: "\(baseURLforDetails)\(placeId)&key=\(googleAPIkey)")
        let data = NSData(contentsOfURL: url!)
        //get the json result
        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
        if let result = json["result"] as? NSDictionary {
            completion(result: true, data: result)
        }
    }
    
    
    
    
    //Get the detailed location information based on the place id.  Same function as the above location.
    //Note shoudl clean this up later
    func getLocationDetails(data: NSDictionary, completion: (result: Bool, data: NSDictionary)->()) {
        let placeId = data["place_id"] as! String
        let url = NSURL(string: "\(baseURLforDetails)\(placeId)&key=\(googleAPIkey)")
        let data = NSData(contentsOfURL: url!)
        //get the json result of as a NSDictionary
        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
        if let result = json["result"] as? NSDictionary {
            completion(result: true, data: result)
        }
    }
    
    //Ge the types object for a location object.  Function requires a NSDictionary object and returns an array if strubgs
    func getTypesForLocation (data: NSDictionary) -> [String] {
        var results: [String] = []
        //get the value for "types" key
        if let types = data["types"] as? NSArray{
            for index in 0..<types.count{
                results.append(types[index] as! String)
            }
        }
        return results
        
    }
    
    //Get the official name of the location object.  Requries a NSDictionary object and returns a String
    func getFullName(data: NSDictionary) -> String {
        //get the value for "name" key
        if let name = data["name"] as? String {
            return name
        } else {
            return "Different Place"
        }
    }
    
    
    /**********
     
     Get Restaurant Functions.
     
     Functions are used to grab a Restaurant's coordinate, information, picture, type, and map info
     
     **********/

    //Get the Restarurant json object as a NSDictionary object.  Google search based on the location coordinates and location name.
    func getRestaurantMapInfo (latitude: Float, longitude: Float, restaurantName: String, completion: (result: Bool, data: NSDictionary)->()) {
        //get the url used for NSData
        let restaurantString = restaurantName.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        let urlString = "\(baseURLforLocation)\(latitude),\(longitude)&radius=10000&name=\(restaurantString)&key=\(googleAPIkey)"
        
        let url = NSURL(string: "\(baseURLforLocation)\(latitude),\(longitude)&radius=18000&type=restaurant&name=\(restaurantString)&key=\(googleAPIkey)")
        //get the data from the url string above
        let data = NSData(contentsOfURL: url!)
        //get the json data from the NSData as an NSDictionary object
        let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
        //parse the json result to grab the desired results
        if let result = json["results"] as? NSArray {
            //the first result (hypothetically) should be the same as our search query (locationString).  Make sure the result we are grabbing is for the correct location
            let restaurantResult = result[0] as! NSDictionary
            //send the closure that we have successfully grabbed the data and send it within the data object
            completion(result: true, data: restaurantResult)
        
        }
    }
    
    
    //Get the official address object of the location.  Requires a NSDictionary object and returns a String.
    func getLocationAddress (data: NSDictionary) -> String {
        let address = data["vicinity"] as! String
        return address
    }
    
    //Get the website object of the location.  Requires a NSDictionary object and returns a String.  If website doesn't exist, return an empty string
    func getLocationWebsite (data: NSDictionary) -> String {
        if let website = data["website"] as? String {
            return website
        } else {
            return ""
        }
    }
    
    //Get the phone number of the location.  Requires a NSDictionary object and returns a String.  If phone number doesnt exist for this location, return an empty string.
    func getLocationPhoneNumber (data: NSDictionary) -> String {
        if let phoneNumber = data["formatted_phone_number"] as? String {
            return phoneNumber
        } else {
            return ""
        }
    }
    
    //Get the rating object of the location.  Requires a NSDictionary object and returns a String. Return an empty string of the rating doesn't exist for the object
    func getLocationRating (data: NSDictionary) -> String {
        if let rating = data["rating"] as? Float {
            return String(rating)
        } else {
            return ""
        }
    }
    
    //Get the hours of operation for the location.  Requires a NSDictionary object and returns an array of strings
    func getLocationAvailability (data: NSDictionary) -> [String] {
        var results: [String] = []
        //get the value of the "opening_hours" key and loop through each object and add it to the array
        if let hours = data["opening_hours"] as? NSDictionary {
            if let weekday_text = hours["weekday_text"] as? NSArray {
                for index in 0..<weekday_text.count {
                    results.append(weekday_text[index] as! String)
                }
            }
        }
        return results
    }
    
    //Get the price object of the location.
    func getLocationPrice (data: NSDictionary) -> Int {
        if let price = data["price_level"] as? Int {
            return price
        } else {
            return 0
        }
    }
    
    //Get the full name of the location data.  Requires a NSDictionary object and returns a String
    func getLocationFullName (data: NSDictionary) -> String {
        if let name = data["name"] as? String {
            return String(name)
        } else {
            return ""
        }
    }
    
    
    
    //Overall function that to get all the relevant infromation from the NSDictionary object.  Returns dictionary object that holds all the required information.
    func getLocationDetailsAllInformation (data: NSDictionary) -> Dictionary<String, AnyObject> {
        
        // variables to hold certain objects.
        var locationDictionary: Dictionary<String, AnyObject> = [:]
        var locationImage : NSData = NSData()
        var typeString: String = ""
        var locationPhoneNumber = ""
        var locationAvailability: [String] = []
        var locationWebsite: String = ""
        var locationAddress: String = ""
        var locationPrice: Int = 0
        var locationRating: String = ""
        var locationLatitude: Double = 0
        var locationLongitude: Double = 0
        var locationName: String = ""
        
        //Get the picture data and store it as a NSData
        let image = getPictureForLocation(80, data: data)
        locationImage = image!
        
        
        //Get the location type as a string
        let typesArray: [String] = getTypesForLocation(data)
        //Type will typically have more than one value.  Get the values right before "point of interest"
        typeString = typesArray[0]
        for index in 1..<typesArray.count {
            if typesArray[index ] == "point_of_interest" {
                break
            }
            typeString += ", " + typesArray[index]
        }
        typeString = typeString.stringByReplacingOccurrencesOfString("_", withString: " ")
        
        
        //Get a more detailed JSON object to be able to gather more information
        getLocationDetails(data, completion: { (result, data) in
            if result {
                
                //Get the phone number of the location
                locationPhoneNumber = self.getLocationPhoneNumber(data)
                
                //Get the availability of the location
                locationAvailability = self.getLocationAvailability(data)
                
                //Get the website of the location
                locationWebsite = self.getLocationWebsite(data)
                
                //Get the address of the location
                locationAddress = self.getLocationAddress(data)
                
                //Get the price of the location
                locationPrice = self.getLocationPrice(data)
                
                //get the rating of the location
                locationRating = self.getLocationRating(data)
                
                //Used to get the coordinates for the location for map info.
                if let coordinates = self.getLocationCoordinates(data){
                    locationLatitude = coordinates.0
                    locationLongitude = coordinates.1
                }
                
                //Get full name of the location
                locationName = self.getLocationFullName(data)
                
            }
        }) //end of getting detailed info
        
        //Set the dictionary key value objects
        locationDictionary["image"] = locationImage
        locationDictionary["type"] = typeString
        locationDictionary["phonenumber"] = locationPhoneNumber
        locationDictionary["availability"] = locationAvailability
        locationDictionary["website"] = locationWebsite
        locationDictionary["address"] = locationAddress
        locationDictionary["price"] = locationPrice
        locationDictionary["rating"] = locationRating
        locationDictionary["latitude"] = locationLatitude
        locationDictionary["longitude"] = locationLongitude
        locationDictionary["city"] = city
        locationDictionary["name"] = locationName
        
        //return the result
        return locationDictionary
        
    }
    
}


