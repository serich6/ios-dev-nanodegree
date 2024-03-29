//
//  LoginVC.swift
//  On The Map
//
//  Created by Sam Rich on 5/29/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation
import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var udacityLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailAddressTextField.delegate = self
        passwordTextField.delegate = self
        emailAddressTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //    MARK: Button Handlers
    @IBAction func clickLoginButton(_ sender: Any) {
        isLogginIn(inProgress: true)
        UdacityClient.loginRequest(password: passwordTextField.text ?? "", emailAddress: emailAddressTextField.text ?? "", completion: handleLoginRequest(success:errorMsg:))
        isLogginIn(inProgress: false)
    }
    
    func handleLoginRequest(success: Bool, errorMsg: String?) {
        if success {
            DispatchQueue.main.async {
                self.emailAddressTextField.text = ""
                self.passwordTextField.text = ""
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                if DataModel.user.firstName == "" && DataModel.user.lastName == "" {
                    UdacityClient.getUserData(completion: self.handleUserData(bool:error:))
                }
            }
        } else {
            guard let message = errorMsg else {
                return
            }
            DispatchQueue.main.async {
                self.showLoginFailure(message: message)
            }
        }
    }
    
    func handleUserData(bool: Bool, error: Error?) {
        if error != nil {
            showNoUserDataAlert()
        }
    }
    
    func showNoUserDataAlert() {
        let alert = UIAlertController(title: "No User Data", message: "There was a problem fetching your user data to use when creating new pins. Defaulting to test values.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func isLogginIn(inProgress: Bool) {
        emailAddressTextField.isEnabled = !inProgress
        passwordTextField.isEnabled = !inProgress
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    // Advance the keyboard in the case of smaller devices
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailAddressTextField {
            emailAddressTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
            clickLoginButton(self)
        }
        return true
    }
    
    
    // MARK: Keyboard Methods from my MemeMe project
    // Behavior for keyboard hiding -> reset the view to its base level
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    //Behavior for keyboard showing: move the frame up vertically per the height of the keyboard
    @objc func keyboardWillShow(_ notification:Notification) {
        // TODO: I'm getting some odd jumping behavior on this animation, but it could be the toolbar constraints?
        if (emailAddressTextField.isEditing){
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
}
