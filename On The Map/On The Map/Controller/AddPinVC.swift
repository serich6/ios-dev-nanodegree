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
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    var newPin: StudentInformation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func findButtonClicked(_ sender: Any) {
        let locationString = searchField.text ?? "Unable to geocode location"
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(locationString) { (placemarkers, error) in
            print("in geocode block")
            var place: CLPlacemark!
            place = placemarkers?[0]
            let lat = place?.location?.coordinate.latitude
            let long = place?.location?.coordinate.longitude
            
            self.newPin = StudentInformation(firstName: DataModel.user.firstName, lastName: DataModel.user.lastName, longitude: long!, latitude: lat!, mapString: locationString, mediaURL: "", uniqueKey: DataModel.user.userKey, objectId: "", createdAt: "", updatedAt: "")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "showEnterLinkScreen", sender: nil)
            }
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
         performSegue(withIdentifier: "returnToTabView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEnterLinkScreen"{
            print("reached prepare method!")
            let enterLinkVC = segue.destination as! EnterLinkVC
            enterLinkVC.temporaryPin = newPin
            print(enterLinkVC.temporaryPin)
        }
    }
}
