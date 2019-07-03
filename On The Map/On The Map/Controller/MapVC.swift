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
    @IBOutlet weak var pinButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    var isPost: Bool!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addPins()
        if DataModel.user.firstName == "" && DataModel.user.lastName == "" {
            UdacityClient.getUserData(completion: handleUserData(bool:error:))
        }
    }
    
    func handleUserData(bool: Bool, error: Error?) {
        if error != nil {
            print(error)
            showNoUserDataAlert()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        addPins()
    }
    
    // Adapted from the example PinApp, reformatted as per code review feedback
    func addPins() {
        _  = PinClient.getPins() { pins, error in
            if error != nil {
                self.showPinDownloadErrorAlert()
            } else {
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
                        self.showNoPinsAlert()
                    }
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
            pinView?.isEnabled = true
            pinView?.canShowCallout = true
            // I wasn't able to get the regular callout bubble to open the link correctly on tap once it was already open, so I added a button as a workaround.
            let linkButton = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = linkButton
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // I think in the last test run, the links without http://www.*** stopped working. Will debug later.
        let urlString = view.annotation?.subtitle
        if let url = URL(string: urlString as! String) {
             UIApplication.shared.open(url)
        }
    }
    
    @IBAction func clickLogoutButton(_ sender: Any) {
        UdacityClient.logoutRequest(completion: handleLogOut(bool:error:))
    }
    
    func handleLogOut(bool: Bool, error: Error?){
        DispatchQueue.main.async {
            if bool {
                self.dismiss(animated: true, completion: nil)
            } else {
                print(error)
                self.showNoPinsAlert()
            }
        }
    }
    
    @IBAction func clickPinButton(_ sender: Any) {
        if DataModel.userPinAddedForSession {
            DispatchQueue.main.async {
                self.showOverwritePinPrompt()
            }
        } else {
            isPost = true
            performSegue(withIdentifier: "addPinFromMapSegue", sender: nil)
        }
    }
    
    func handleOverwrite(action: UIAlertAction) {
        isPost = false
        performSegue(withIdentifier: "addPinFromMapSegue", sender: nil)
    }
    
    func showOverwritePinPrompt() {
        let alert = UIAlertController(title: "Pin for user already exists", message: "You have already created a pin. Would you like to overwrite it?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: handleOverwrite))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLoginErrorAlert() {
        let alert = UIAlertController(title: "There was an error attempting to log out", message: "Please try again.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showNoPinsAlert() {
        let alert = UIAlertController(title: "No Pins Available", message: "There are no pins available to view.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showPinDownloadErrorAlert() {
        let alert = UIAlertController(title: "Unable to download pins", message: "Please try again.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showNoUserDataAlert() {
        let alert = UIAlertController(title: "No User Data", message: "There was a problem fetching your user data to use when creating new pins. Defaulting to test values.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showPinDownloadIssueAlert() {
        let alert = UIAlertController(title: "Download Pin Error", message: "There was a problem downloading the pins. Please try again.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPinFromMapSegue"{
            let addPinVC = segue.destination as! AddPinVC
            addPinVC.isPost = isPost
        }
    }
}
