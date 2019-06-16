//
//  FirstViewController.swift
//  On The Map
//
//  Created by Sam Rich on 5/29/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addPins()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPins()
    }
    
    // Adapted from the example PinApp
    // For some reason right now I'm having to call this twice - this may be related to the similar issue in the table VC where
    // I can't seem to get the initial load correct
    func addPins() {
        _  = PinClient.getPins() { pins, error in
            DataModel.pinData = pins!
            self.mapView.reloadInputViews()
        }
        var annotations = [MKPointAnnotation]()
        //let locations = hardCodedLocationData()
        let locations = DataModel.pinData
        
        for pin in locations {
            let lat = CLLocationDegrees(pin.latitude)
            let long = CLLocationDegrees(pin.longitude)
            let first = pin.firstName
            let last = pin.lastName
            let mediaURL = pin.mediaURL
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        print(annotations)
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
    
    // Adapted from the example PinApp
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        let reuseId = "studentPin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
}

