//
//  ViewController.swift
//  Virtual Tourist
//
//  Created by Sam Rich on 7/1/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapVC: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    // TODO: Save off the map center coordinates for next launch (UserDefaults?)
    var mapCenterCoordinate: CLLocationCoordinate2D!
    var currentPin: Pin!
    var currentPhotoArray: [String]! = []
    var dataController:DataController!
    var fetchedResultsController:NSFetchedResultsController<Pin>!
    var downloadedPhotos: [Data]!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        addLongPressRecognizer()
        drawPinsFromCoreData()
        if UserDefaults.standard.double(forKey: "mapLat") != nil {
            mapView.centerCoordinate.latitude = UserDefaults.standard.double(forKey: "mapLat")
            mapView.centerCoordinate.longitude = UserDefaults.standard.double(forKey: "mapLong")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func drawPinsFromCoreData() {
        let pins = fetchAllPinsFromDataModel()
        for pin in pins {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude as! CLLocationDegrees, longitude: pin.longitude as! CLLocationDegrees)
            self.mapView.addAnnotations([annotation])
        }
        
    }
    
    func fetchAllPinsFromDataModel() -> [Pin] {
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        let predicateString = "latitude != 0"
        fetchRequest.predicate = NSPredicate(format: predicateString)
        do {
            let fetchedPins = try dataController.viewContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [Pin]
            return fetchedPins
        } catch {
            fatalError("Failed to fetch pin: \(error)")
        }
    }
    
    // Idea from: https://stackoverflow.com/questions/30858360/adding-a-pin-annotation-to-a-map-view-on-a-long-press-in-swift
    fileprivate func addLongPressRecognizer() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        longPressRecognizer.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressRecognizer)
    }
    
    // Idea from: https://stackoverflow.com/questions/30858360/adding-a-pin-annotation-to-a-map-view-on-a-long-press-in-swift
    @objc func handleLongPress(_ gestureRecognizer : UIGestureRecognizer){
        if gestureRecognizer.state != .began { return }
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        self.mapView.addAnnotations([annotation])
        addPinToModel(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    func addPinToModel(latitude: Double, longitude: Double) {
        let pin = Pin(context: dataController.viewContext)
        pin.latitude = latitude as NSNumber
        pin.longitude = longitude as NSNumber
        try? dataController.viewContext.save()
    }
    
    // Modeled after mooskine example
    func fetchPinFromDataModel(lat: Double, long: Double) -> [Pin] {
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        let predicateString = "latitude = \(lat) AND longitude = \(long)"
        fetchRequest.predicate = NSPredicate(format: predicateString)
        do {
            let fetchedPins = try dataController.viewContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [Pin]
            return fetchedPins
        } catch {
            fatalError("Failed to fetch pin: \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCollectionSegue"{
            let photoAlbumVC = segue.destination as! PhotoAlbumVC
            photoAlbumVC.temporaryPin = currentPin
            photoAlbumVC.dataController = dataController
        }
    }
}

extension MapVC: MKMapViewDelegate {
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
        print("pin tapped")
        if let coordinate = view.annotation?.coordinate {
            let foundPins = fetchPinFromDataModel(lat: coordinate.latitude, long: coordinate.longitude)
            guard foundPins.first != nil else {
                showCustomErrorAlert(title: "Pin query error", message: "There was a problem querying the pin from core data. Please try again.")
                return
            }
            currentPin = foundPins.first
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "showCollectionSegue", sender: nil)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let lat = Double(mapView.centerCoordinate.latitude.description)
        let long = Double(mapView.centerCoordinate.longitude.description)
        UserDefaults.standard.set(lat, forKey: "mapLat")
        UserDefaults.standard.set(long, forKey: "mapLong")
    }
    
    func showCustomErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

