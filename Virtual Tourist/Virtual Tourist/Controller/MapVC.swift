//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Sam Rich on 7/1/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    // TODO: Save off the map center coordinates for next launch (UserDefaults?)
    var mapCenterCoordinate: CLLocationCoordinate2D!
    var temporaryPin: MKAnnotationView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        addLongPressRecognizer()
        //TODO: figure out how to remove force downcasting
//        if let userCenterLat = UserDefaults.standard.value(forKey: "userCenterLat"), let userCenterLong = UserDefaults.standard.value(forKey: "userCenterLong") {
//            print("there is a user lat long present")
//            let coordinate = CLLocationCoordinate2D(latitude: userCenterLat as! CLLocationDegrees, longitude: userCenterLong as! CLLocationDegrees)
//            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
//            mapView.setRegion(region, animated: true)
//            mapView.setCenter(coordinate, animated: false)
//        } else {
//            print("this is a first launch, using default center")
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        UserDefaults.standard.set(mapView.centerCoordinate.latitude, forKey: "userCenterLat")
//        UserDefaults.standard.set(mapView.centerCoordinate.longitude, forKey: "userCenterLong")
    }
    
    //TODO: Cite stack overflow idea here
    // https://stackoverflow.com/questions/30858360/adding-a-pin-annotation-to-a-map-view-on-a-long-press-in-swift
    fileprivate func addLongPressRecognizer() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        longPressRecognizer.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressRecognizer)
    }
    
    
    @objc func handleLongPress(_ gestureRecognizer : UIGestureRecognizer){
        if gestureRecognizer.state != .began { return }
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        self.mapView.addAnnotations([annotation])
        //TODO: Add pin to data model
        
    }
    
    // Adapted from the example PinApp
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        let reuseId = "touristPin"
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
    
    // For when the pin is tapped
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("something was tapped!")
        temporaryPin = view
        // pull the pin from data model instead, and use that lat/long
        let lat = view.annotation?.coordinate.latitude
        let long = view.annotation?.coordinate.longitude
        FlickerClient.getPhotoPage(latitude: lat!, longitude: long!, completion: handlePhotoResponse)
        //need to also pass the pin information in the segue so that the next view is correctly centered
    }
    
    // Open the new view, passing along the photos that need to be populated
    // Otherwise, throw up an error that there was a problem
    func handlePhotoResponse(photos: [FlickrPhoto]?, error: Error?) {
        //TODO: stuff here
        // bring up the view controller/segue
        if error != nil {
            showGetPhotosErrorAlert()
            return
        } else {
            DispatchQueue.main.async {
                print("in handle photo response block")
                self.performSegue(withIdentifier: "showCollectionSegue", sender: nil)
            }
        }
        
    }
    
    func showGetPhotosErrorAlert() {
        let alert = UIAlertController(title: "Photo download error", message: "There was a problem downloading the photos from Flickr. Please try again.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCollectionSegue"{
            let photoAlbumVC = segue.destination as! PhotoAlbumVC
            photoAlbumVC.temporaryPin = temporaryPin
        }
    }
}

