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
    var temporaryPhotoDataArray: [Data] = []
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
        temporaryPhotoDataArray = []
        for photo in result {
            temporaryPhotoDataArray.append(photo.image!)
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
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
                print("there are no photos, fetching from flickr!")
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
        self.convertURLsToData(photoUrls: self.temporaryPhotoURLs)
        for data in temporaryPhotoDataArray {
            savePhotosToStorage(data: data)
        }
        DispatchQueue.main.async {
            if self.temporaryPhotoURLs.count > 0 {
                self.setToolBarTitle(isNewCollection: true)
                self.toggleNewCollection(isEnabed: true)
            }
            self.collectionView.reloadData()
        }
    }

    
    func convertURLsToData(photoUrls: [String]) {
        temporaryPhotoDataArray = []
        for url in photoUrls {
            if let data = try? Data(contentsOf: URL(string:url)!) {
                temporaryPhotoDataArray.append(data)
            } else {
                print("Error loading data from url string in convertURLsToData")
            }
        }
    }
    
    func savePhotosToStorage(data: Data) {
        let photoToSave = Photo(context: dataController.viewContext)
        photoToSave.image = data
        temporaryPin.addToPhotos(photoToSave)
        print(temporaryPin.photos)
        try? dataController.viewContext.save()
    }
    
    func deletePhotosFromStorage() {
       print("TODO: implement delete photos to persistant store here")
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
        toolBarButton.isEnabled = true
    }
    
    @IBAction func toolBarButtonClicked() {
        temporaryPin.removeFromPhotos(temporaryPin.photos!)
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
        // if the temporary url array has a url in it, set to the image from there
        // otherwise, use the placeholder
        cell.photoImageView.image = UIImage(named: "icon_world")
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        
        if temporaryPhotoDataArray.indices.contains(indexPath.row) {
            if let image = UIImage(data: temporaryPhotoDataArray[indexPath.row]) {
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
    
    // TODO: implement this for selecting photos
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //get the photo for that pin with that data
        // remove it from storage
        //remove it from the backing array
        temporaryPhotoDataArray.remove(at: indexPath.row)
        collectionView.reloadData()
    }
}
