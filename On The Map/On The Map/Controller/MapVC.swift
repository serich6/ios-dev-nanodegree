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
    
    func showOverwritePinPrompt() {
//        let alertVC = UIAlertController(title: "Pin already exists", message: "A pin already exists for your acount. Do you want to overwrite the existing pin?", preferredStyle: .alert)
//        alertVC.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { action in
//           self.handleOverwrite()
//        }))
//       // alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
//        //self.present(UIViewController, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)(alertVC, sender: nil)
//        show(alertVC, sender: nil)
    }
    
    func handleOverwrite() {
        isPost = false
        performSegue(withIdentifier: "addPinFromMapSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPinFromMapSegue"{
            let addPinVC = segue.destination as! AddPinVC
            addPinVC.isPost = isPost
        }
    }
}
