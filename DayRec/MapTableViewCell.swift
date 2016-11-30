//
//  MapTableViewCell.swift
//  DayReco
//
//  Created by Victor Wei on 10/5/16.
//  Copyright © 2016 VictorW. All rights reserved.
//

import UIKit
import MapKit

class MapTableViewCell: UITableViewCell, MKMapViewDelegate {

    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var latitude : Float = 0
    var longitude: Float = 0
    
    var locationTitle: String = ""
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        mapView.delegate = self
        mapView.mapType = .Standard
        
        updateLocation()
        addAnnotationToMap()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func updateLocation() {
        var mapRegion = mapView.region
        
        
        let location = CLLocation(latitude: Double(latitude), longitude: Double(longitude))
        
        mapRegion.center.latitude = location.coordinate.latitude
        mapRegion.center.longitude = location.coordinate.longitude
        
        mapRegion.span.latitudeDelta = 0.05
        mapRegion.span.longitudeDelta = 0.05
        
        mapView.setRegion(mapRegion, animated: true)
    
    }
    
    
    func addAnnotationToMap() {
        
        let location = CLLocation(latitude: Double(latitude), longitude: Double(longitude))
        let coordinateLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let annotation = LocationAnnotation(coordinate: coordinateLocation, title: locationTitle)
        
        mapView.addAnnotation(annotation)
        
    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("locationAnnotation")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "locationAnnotation")
            
            
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
}
