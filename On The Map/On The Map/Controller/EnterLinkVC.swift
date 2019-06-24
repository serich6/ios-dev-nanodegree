//
//  EnterLinkVC.swift
//  On The Map
//
//  Created by Sam Rich on 6/16/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class EnterLinkVC: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPin()
        // TODO: remove example code below, this was just for getting the centering property figured out
        let pin = DataModel.pinData.first
        let lat = CLLocationDegrees(pin!.latitude)
        let long = CLLocationDegrees(pin!.longitude)
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: long)
        mapView.setCenter(coord, animated: false)
        
    }
    
    func submitButtonClicked() {
        // Do the post command here
        performSegue(withIdentifier: "pinSubmittedSegue", sender: nil)
    }
    
    // Adapted from the example PinApp
    // For some reason right now I'm having to call this twice - this may be related to the similar issue in the table VC where
    // I can't seem to get the initial load correct
    func addPin() {

        var annotations = [MKPointAnnotation]()
        let pin = DataModel.pinData.first
        let lat = CLLocationDegrees(pin!.latitude)
        let long = CLLocationDegrees(pin!.longitude)
        let first = pin!.firstName
        let last = pin!.lastName
        let mediaURL = pin!.mediaURL
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL
        
        // Finally we place the annotation in an array of annotations.
        annotations.append(annotation)
        
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        print(annotations)
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
    
    // Adapted from the example PinApp
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        let reuseId = "singlePin"
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
