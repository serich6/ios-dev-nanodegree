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
        mapView.delegate = self
        addPins()
    }
    
    // Adapted from the example PinApp, reformatted as per code review feedback
    func addPins() {
        _  = PinClient.getPins() { pins, error in
            DispatchQueue.main.async {
                if let locations = pins{
                    DataModel.pinData = pins!
                    self.mapView.reloadInputViews()
                    var annotations = [MKPointAnnotation]()
                    for pin in locations {
                        let lat = CLLocationDegrees(pin.latitude)
                        let long = CLLocationDegrees(pin.longitude)
                        let first = pin.firstName
                        let last = pin.lastName
                        let mediaURL = pin.mediaURL
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(first) \(last)"
                        annotation.subtitle = mediaURL
                        annotations.append(annotation)
                    }
                    self.mapView.addAnnotations(annotations)
                }
                else{
                    // There are no pins/student locations
                }
            }
        }
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

