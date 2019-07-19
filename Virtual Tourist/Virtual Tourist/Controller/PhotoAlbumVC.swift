//
//  PhotoAlbumVC.swift
//  Virtual Tourist
//
//  Created by Sam Rich on 7/1/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PhotoAlbumVC: UIViewController, MKMapViewDelegate, UICollectionViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolBarTitle: UIBarButtonItem!
   // var temporaryPin: MKAnnotationView!
    var temporaryPin: Pin!
    // TODO: add a photo album here - if it's nil when we preform the segue, add the label No Images
    var hasPhotos: Bool = false
    // TODO: figure out if I need to use this to save off the coordinate in user defaults
    var mapCenterCoordinate: CLLocationCoordinate2D!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        collectionView.delegate = self
        setToolBarTitle()
        drawPin()
        setMapZoom()
    }
    
    // Update the UI with the correct tool bar title/label depending on if we have photos to display or not.
    func setToolBarTitle() {
        if let photos = temporaryPin.photos {
            if photos.count > 0 {
                toolBarTitle.title = "New Collection"
            }
            else {
                toolBarTitle.title = "No Images"
            }
        }
    }
    
    func drawPin(){
        guard let pin = temporaryPin else {
            showDisplayPinErrorAlert()
            return
        }
        let annotation = MKPointAnnotation()
        //TODO: remove force unwrap here
        //annotation.coordinate = pin.annotation!.coordinate
        annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude as! CLLocationDegrees, longitude: pin.longitude as! CLLocationDegrees)
        self.mapView.addAnnotations([annotation])
    }
    
    func showDisplayPinErrorAlert() {
        let alert = UIAlertController(title: "Unable to display placed pin.", message: "There was a problem displaying the pin you dropped. Please try again.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showMapZoomErrorAlert() {
        let alert = UIAlertController(title: "Unable to zoom and center the map.", message: "There was a problem setting the map zoom. Please try again.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setMapZoom() {
        if let pin = temporaryPin {
            let coordinate = CLLocationCoordinate2D(latitude: pin.latitude as! CLLocationDegrees, longitude: pin.longitude as! CLLocationDegrees)
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
            mapView.setRegion(region, animated: true)
            mapView.setCenter(coordinate, animated: false)
        } else {
            showMapZoomErrorAlert()
            return
        }
        //        guard let coordinate = temporaryPin.annotation?.coordinate else {
        //            showMapZoomErrorAlert()
        //            return
        //        }
        //        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
        //        mapView.setRegion(region, animated: true)
        //        mapView.setCenter(coordinate, animated: false)
    }
}
