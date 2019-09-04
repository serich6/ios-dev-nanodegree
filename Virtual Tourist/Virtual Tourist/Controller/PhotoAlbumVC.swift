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
    var temporaryPin: Pin!
    var temporaryPhotoURLs: [String]! = ["https://live.staticflickr.com/7108/7562919526_0079d66ded_s.jpg", "https://live.staticflickr.com/7108/7562919526_0079d66ded_s.jpg", "https://live.staticflickr.com/7108/7562919526_0079d66ded_s.jpg", "https://live.staticflickr.com/7108/7562919526_0079d66ded_s.jpg"]
    var temporaryPhotoDataArray: [Photo] = []
    var hasPhotos: Bool = false
    var mapCenterCoordinate: CLLocationCoordinate2D!
    var dataController:DataController!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        collectionView.delegate = self
        print("Current Pin is: " + temporaryPin.debugDescription)
        setToolBarTitle()
        drawPin()
        setMapZoom()
        getPinPhotos()
    }
    
    
    func getPinPhotos() {
        guard let temporaryPin = temporaryPin else {
            print("pin isn't set")
            return
        }
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", temporaryPin)
        fetchRequest.predicate = predicate
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            if result.count == 0 {
                print("there are no photos, fetching from flickr!")
                FlickerClient.getPhotoPage(latitude: temporaryPin.latitude as! Double , longitude: temporaryPin.longitude as! Double , completion: handlePhotoResponse)
            } else {
                print("I FOUND PIN PHOTOS")
                print("Photos Count: \(result.count)")
            }
        } else {
            showCustomErrorAlert(title: "Error loading pin from core data.", message: "Please try again.")
        }
    }
    
//    func checkForPinPhotos(foundPins: [Pin], coordinate: CLLocationCoordinate2D) {
//        if let photos = temporaryPin.photos {
//            if photos.count == 0 {
//                FlickerClient.getPhotoPage(latitude: coordinate.latitude , longitude: coordinate.longitude , completion: handlePhotoResponse)
//                return
//            } else {
//                // do something here
//                print("Pin exists, and has \(photos.count) associated photos")
//            }
//        }
//    }
    
    // Open the new view, passing along the photos that need to be populated
    // Otherwise, throw up an error that there was a problem
    func handlePhotoResponse(photos: [FlickrPhoto]?, error: Error?) {
        if error != nil {
            showCustomErrorAlert(title: "Photo download error", message: "There was a problem downloading the photos from Flickr. Please try again.")
            return
        }
        if let photosToID = photos {
            let photoURLs = FlickerClient.convertFlikrPhotosToURLArray(photoSearchResults: photosToID)
            for url in photoURLs {
                print(url)
                FlickerClient.downloadImageData(photoURL: url, completion: placeholderCompletion(data:error:))
            }
        }
        // This needs to go somewhere else - it's getting called before the array has been processed.
        handleArrayComplete()
    }
    
    func placeholderCompletion(data: Data?, error: Error?) {
        DispatchQueue.main.async {
            if error != nil {
                print(error)
                self.showCustomErrorAlert(title: "placeholder error", message: error.debugDescription)
                return
            } else {
                print(data)
            }
        }
    }
    
    func handleGetPhotoImageURLResponse(photoURLs: String?, error: Error?) {
        if error != nil {
            print(error as Any)
            showCustomErrorAlert(title: "Fetch Image URL error", message: "There was an issue fetching the image URL. Please try again.")
            return
        }
        if let url = photoURLs {
            temporaryPhotoURLs.append(url)
        }
    }
    
    func handleArrayComplete() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showCollectionSegue", sender: nil)
        }
    }
}

// UI functions
extension PhotoAlbumVC {
    func showCustomErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
        //cell.photoImageView.image = UIImage
        //cell.activityIndicator.isAnimating = false
        let url = URL(string:"https://live.staticflickr.com/7108/7562919526_0079d66ded_s.jpg")!
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.photoImageView.image = image
                }
            }
        }
        return cell
    }
    
    // TODO: implement this for selecting photos
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell tapped!")
        //remove the photo from the backing array
        temporaryPhotoURLs.remove(at: indexPath.row)
        // delete the photo from persistant storage:
        // TODO!
        //reload the view
        collectionView.reloadData()
    }
}
