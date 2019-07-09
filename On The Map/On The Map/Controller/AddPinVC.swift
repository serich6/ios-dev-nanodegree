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

class AddPinVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    var newPin: StudentInformation!
    var isPost: Bool! = true
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        searchField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
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
    
    // MARK: Keyboard Methods from my MemeMe project
    // Behavior for keyboard hiding -> reset the view to its base level
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    //Behavior for keyboard showing: move the frame up vertically per the height of the keyboard
    @objc func keyboardWillShow(_ notification:Notification) {
        // TODO: I'm getting some odd jumping behavior on this animation, but it could be the toolbar constraints?
        if (searchField.isEditing){
            // Used divide by 3 since otherwise it was a very drastic shift.
            view.frame.origin.y -= getKeyboardHeight(notification) / 3
        }
    }
    
    //Determine the keyboard height
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    //Add keyboard notifications
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //Remove keyboard notifications
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Advance the keyboard in the case of smaller devices
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchField {
            searchField.resignFirstResponder()
            findButtonClicked(self)
        }
        return true
    }
}
