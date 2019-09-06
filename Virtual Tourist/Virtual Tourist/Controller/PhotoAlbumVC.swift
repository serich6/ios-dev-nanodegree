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
    @IBOutlet weak var toolBarButton: UIButton!
    var temporaryPin: Pin!
    var temporaryPhotoURLs: [String]! = []
    var photosArray : [Photo] = []
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
        collectionView.reloadData()
        drawPin()
        setMapZoom()
        setToolBarTitle(isNewCollection: false)
        getPinPhotos()
    }
    
    fileprivate func displayPreviouslySavedPhotos(_ result: [Photo]) {
        print("Photos Count: \(result.count)")
        DispatchQueue.main.async {
            self.setToolBarTitle(isNewCollection: true)
            self.toggleNewCollection(isEnabed: false)
        }
        for photo in result {
            photosArray.append(photo)
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.toggleNewCollection(isEnabed: true)
        }
    }
    
    func getPinPhotos() {
        guard let temporaryPin = temporaryPin else {
            showCustomErrorAlert(title: "Pin is Nil", message: "Try again.")
            return
        }
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", temporaryPin)
        fetchRequest.predicate = predicate
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            if result.count == 0 {
                FlickerClient.getPhotoPage(latitude: temporaryPin.latitude as! Double , longitude: temporaryPin.longitude as! Double , completion: handlePhotoResponse)
            } else {
                displayPreviouslySavedPhotos(result)
            }
        } else {
            showCustomErrorAlert(title: "Error loading pin from core data.", message: "Please try again.")
        }
    }
    
    // Open the new view, passing along the photos that need to be populated
    // Otherwise, throw up an error that there was a problem
    func handlePhotoResponse(photos: [FlickrPhoto]?, error: Error?) {
        //the count is known here
        if error != nil {
            showCustomErrorAlert(title: "Photo download error", message: "There was a problem downloading the photos from Flickr. Please try again.")
            return
        }
        if let photosToID = photos {
            handlePhotoArrayConversions(photosToID)
        }
    }
    
    fileprivate func handlePhotoArrayConversions(_ photosToID: [FlickrPhoto]) {
        if photosToID.count == 0 {
            DispatchQueue.main.async {
                self.setToolBarTitle(isNewCollection: false)
                self.toggleNewCollection(isEnabed: false)
                print("No images found after call to flickr")
            }
        } else {
            FlickerClient.convertFlikrPhotosToURLArray(photoSearchResults: photosToID, completion: placeholderCompletion(photoUrls:error:))
        }
    }
    
    
    func placeholderCompletion(photoUrls: [String]?, error: Error?) {
        DispatchQueue.main.async {
            if error != nil {
                print(error)
                return
            } else {
                self.updateUIStorageWithPhotos(photoUrls: photoUrls!)
            }
        }
    }
    
    fileprivate func updateUIStorageWithPhotos(photoUrls: [String]) {
        self.temporaryPhotoURLs = photoUrls
        self.convertURLsToPhotos(photoUrls: self.temporaryPhotoURLs)
        savePhotosToStorage(photos: photosArray)
        DispatchQueue.main.async {
            if self.photosArray.count > 0 {
                self.setToolBarTitle(isNewCollection: true)
                self.toggleNewCollection(isEnabed: true)
            }
            self.collectionView.reloadData()
        }
    }

    func convertURLsToPhotos(photoUrls: [String]) {
        for url in photoUrls {
            if let data = try? Data(contentsOf: URL(string:url)!) {
                let photoToSave = Photo(context: dataController.viewContext)
                photoToSave.image = data
                photosArray.append(photoToSave)
            } else {
                showCustomErrorAlert(title: "Conversion Error", message: "Error loading photo data from URL")
            }
        }
    }
    
    func savePhotosToStorage(photos: [Photo]) {
        for photoToSave in photos {
            temporaryPin.addToPhotos(photoToSave)
        }
        try? dataController.viewContext.save()
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
    func setToolBarTitle(isNewCollection: Bool) {
        if isNewCollection {
            toolBarButton.titleLabel?.text = "New Collection"
        }
        else {
            toolBarButton.titleLabel?.text = "No Images"
        }
        toggleNewCollection(isEnabed: false)
    }
    
    func toggleNewCollection(isEnabed: Bool){
        // TODO: change back
        toolBarButton.isEnabled = isEnabed
    }
    
    @IBAction func toolBarButtonClicked() {
        let photosToRemove = temporaryPin.photos!
        temporaryPin.removeFromPhotos(photosToRemove)
        getPinPhotos()
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
        annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude as! CLLocationDegrees, longitude: pin.longitude as! CLLocationDegrees)
        self.mapView.addAnnotation(annotation)
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
        if photosArray.count == 0 {
            return 20
        }
        return photosArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        cell.photoImageView.image = UIImage(named: "icon_world")
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        
        if photosArray.indices.contains(indexPath.row) {
            if let image = UIImage(data: photosArray[indexPath.row].image!) {
                DispatchQueue.main.async {
                    cell.photoImageView.image = image
                }
            } else {
               cell.photoImageView.image = UIImage(named: "icon_world")
            }
            cell.activityIndicator.isHidden = true
            cell.activityIndicator.stopAnimating()
        } 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("removing photo at location: \(indexPath.row)")
        temporaryPin.removeFromPhotos(photosArray[indexPath.row])
        photosArray.remove(at: indexPath.row)
        collectionView.reloadData()
    }
}
