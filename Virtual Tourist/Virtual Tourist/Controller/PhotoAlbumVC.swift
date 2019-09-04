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
import CoreData

class PhotoAlbumVC: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var toolBarTitle: UIBarButtonItem!
   // var temporaryPin: MKAnnotationView!
    var temporaryPin: Pin!
    // TODO: remove the hardcoded initial value later
    var temporaryPhotoURLs: [String]! = ["https://live.staticflickr.com/7108/7562919526_0079d66ded_s.jpg"]
    // TODO: add a photo album here - if it's nil when we preform the segue, add the label No Images
    var temporaryPhotoDataArray: [Photo] = []
    var hasPhotos: Bool = false
    // TODO: figure out if I need to use this to save off the coordinate in user defaults
    var mapCenterCoordinate: CLLocationCoordinate2D!
    var dataController:DataController!
    
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
        getPinPhotos()
    }
    
    // TODO: get this to pull the correct pin from
    func getPinPhotos() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", temporaryPin)
        fetchRequest.predicate = predicate
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            print("did the thing")
            print(result)
        } else {
            print("oops")
        }
        //if the pin has associated photos, pull the from core data and save them in the photoData Array
        // otherwise, fetch the images from flickr
    }
    
    // Update the UI with the correct tool bar title/label depending on if we have photos to display or not.
    func setToolBarTitle() {
        if let photos = temporaryPhotoURLs {
            if photos.count > 0 {
                toolBarTitle.title = "New Collection"
            }
            else {
                toolBarTitle.title = "No Images"
            }
        }
    }
}


// Map functions
extension PhotoAlbumVC: MKMapViewDelegate {
    func drawPin(){
        guard let pin = temporaryPin else {
            showDisplayPinErrorAlert()
            return
        }
        let annotation = MKPointAnnotation()
        //TODO: remove force unwrap here
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
    }
}


// Collection view functions
extension PhotoAlbumVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return temporaryPhotoURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        cell.photoImageView.image = UIImage(named: "icon_world")
        //cell.activityIndicator.isAnimating = false
        return cell
    }
    
    // TODO: implement this for selecting photos
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // add stuff here
        //remove the photo from the backing array
        // delete the photo from persistant storage
        //reload the view
        collectionView.reloadData()
    }
}
