//
//  AddPinVC.swift
//  On The Map
//
//  Created by Sam Rich on 6/15/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class AddPinVC: UIViewController {
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var overwriteLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    var newPin: StudentInformation!
    var isPost: Bool! = true
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isPost {
            overwriteLabel.text = ""
        } else {
            overwriteLabel.text = "User pin already exists. To leave the pin as is, cancel at the top of the page. Otherwise, procede."
        }
        activityIndicator.isHidden = true
    }
    
    @IBAction func findButtonClicked(_ sender: Any) {
        activityIndicator.isHidden = false
        let locationString = searchField.text ?? "Unable to geocode location"
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(locationString) { (placemarkers, error) in
            if error != nil {
                self.showGeocodeAlert()
            } else {
                var place: CLPlacemark!
                place = placemarkers?[0]
                let lat = place?.location?.coordinate.latitude
                let long = place?.location?.coordinate.longitude
                self.newPin = StudentInformation(firstName: DataModel.user.firstName, lastName: DataModel.user.lastName, longitude: long!, latitude: lat!, mapString: locationString, mediaURL: "", uniqueKey: DataModel.user.userKey, objectId: "", createdAt: "", updatedAt: "")
                DispatchQueue.main.async {
                    self.activityIndicator.isHidden = true
                    self.performSegue(withIdentifier: "showEnterLinkScreen", sender: nil)
                }
            }
           
        }
    }
    
    func showGeocodeAlert() {
        let alert = UIAlertController(title: "Geocodig Error", message: "There was a problem geocoding your location, please try again.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
         performSegue(withIdentifier: "returnToTabView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEnterLinkScreen"{
            let enterLinkVC = segue.destination as! EnterLinkVC
            enterLinkVC.temporaryPin = newPin
            enterLinkVC.isPost = isPost
        }
    }
}
