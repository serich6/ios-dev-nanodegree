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
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    var temporaryPin : StudentInformation!
    var isPost: Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        addPin()
    }
    
    @IBAction func submitButtonClicked() {
        updateStudentPin()
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "returnToTabView", sender: nil)
    }
    
    func updateStudentPin() {
        temporaryPin.mediaURL = linkTextField.text ?? ""
        if isPost {
            PinClient.postPin(pin: temporaryPin, completion: handleSuccessfulPinPostPut(result:error:))
        } else {
           PinClient.putPin(pin: temporaryPin, completion: handleSuccessfulPinPostPut(result:error:))
        }
        
    }
    
    func handleSuccessfulPinPostPut(result: Bool, error: Error?) {
        if result {
            DataModel.userPinAddedForSession = true
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "pinSubmittedSegue", sender: nil)
            }
        } else {
            showPostErrorAlert()
        }
    }
    
    func showPostErrorAlert() {
        let alert = UIAlertController(title: "POST Pin Error", message: "There was a problem adding the new pin. Please try again.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Adapted from the example PinApp
    func addPin() {
        var annotations = [MKPointAnnotation]()
        let pin = temporaryPin
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
        mapView.setCenter(coordinate, animated: false)
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
