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

class EnterLinkVC: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
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
        linkTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func submitButtonClicked() {
        updateStudentPin()
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "pinSubmittedSegue", sender: nil)
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
        if error != nil {
            showPostErrorAlert()
        }
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
        // From code review feedback
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        mapView.setRegion(region, animated: true)
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
    
    // Advance the keyboard in the case of smaller devices
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == linkTextField {
            linkTextField.resignFirstResponder()
           submitButtonClicked()
        }
        return true
    }
    
    // MARK: Keyboard Methods from my MemeMe project
    // Behavior for keyboard hiding -> reset the view to its base level
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    //Behavior for keyboard showing: move the frame up vertically per the height of the keyboard
    @objc func keyboardWillShow(_ notification:Notification) {
        // TODO: I'm getting some odd jumping behavior on this animation, but it could be the toolbar constraints?
        if (linkTextField.isEditing){
            // Used divide by 3 since otherwise it was a very drastic shift.
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //Determine the keyboard height
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    //Add keyboard notifications
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //Remove keyboard notifications
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
