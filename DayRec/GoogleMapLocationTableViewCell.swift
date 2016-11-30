//
//  GoogleMapLocationTableViewCell.swift
//  DayRec
//
//  Created by Victor Wei on 10/10/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class GoogleMapLocationTableViewCell: UITableViewCell {

    var googleMapView: GMSMapView!
    var latitude: Double!
    var longitude: Double!
    
    @IBOutlet weak var mapContainerView: UIView!
    
    var locationDetails: Dictionary<String, AnyObject>!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    func updateView() {
        
        self.googleMapView = GMSMapView(frame: self.mapContainerView.frame)
        self.addSubview(self.googleMapView)
        
        latitude = locationDetails["latitude"] as! Double
        longitude = locationDetails["longitude"] as! Double
        
        let camera = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: 10.5)
        self.googleMapView.camera = camera
        
        addMarker()
    }
    
    
    
    func addMarker() {
        
        let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let marker = GMSMarker(position: coordinate)
        
        //set the gogole map location/zoom
        let camera = GMSCameraPosition.cameraWithLatitude(latitude, longitude: longitude, zoom: 12.2)
        self.googleMapView.camera = camera
        let title = locationDetails["name"] as! String
        marker.title = "\(title)"
        
        //Add marker to the map
        marker.map = self.googleMapView
        
        
    }
    
    
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
