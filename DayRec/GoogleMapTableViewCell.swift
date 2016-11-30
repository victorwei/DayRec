//
//  GoogleMapTableViewCell.swift
//  DayRec
//
//  Created by Victor Wei on 10/8/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit

import GoogleMaps
import GooglePlaces


class GoogleMapTableViewCell: UITableViewCell, GMSMapViewDelegate {
    
    var googleMapView: GMSMapView!
    var markerArray: [GMSMarker] = []
    var city: City!
    
    @IBOutlet weak var googleContainerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Initalize google map view
//        self.googleMapView = GMSMapView(frame: self.googleContainerView.frame)
//        self.addSubview(self.googleMapView)
    }
    
    
    func updateView() {

        self.googleMapView = GMSMapView(frame: self.googleContainerView.frame)
        self.addSubview(self.googleMapView)
        let camera = GMSCameraPosition.cameraWithLatitude(city.latitude, longitude: city.longitude, zoom: 10.5)
        self.googleMapView.camera = camera

        addMarkers()
    }
    

    
    func addMarkers() {
        for index in 0..<markerArray.count {
            markerArray[index].map = googleMapView
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
