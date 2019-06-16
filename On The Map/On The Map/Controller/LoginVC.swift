//
//  LoginVC.swift
//  On The Map
//
//  Created by Sam Rich on 5/29/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation
import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var udacityLogo: UIImageView!
    
    // TODO: add back in the activity spinner
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailAddressTextField.text = ""
        passwordTextField.text = ""
    }
    
    //    MARK: Button Handlers
    @IBAction func clickLoginButton(_ sender: Any) {
        isLogginIn(inProgress: true)
        //UdacityClient.loginRequest(password: passwordTextField.text ?? "", emailAddress: emailAddressTextField.text ?? "", completion: handleLoginRequest(success:error:))
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
        isLogginIn(inProgress: false)
    }
    
    func handleLoginRequest(success: Bool, error: Error?) {
        if success {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        } else {
            DispatchQueue.main.async {
                self.showLoginFailure(message: "Invalid credentials")
            }
        }
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
    
}
