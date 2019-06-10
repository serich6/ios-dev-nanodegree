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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //    MARK: Button Handlers
    @IBAction func clickLoginButton(_ sender: Any) {
        //set is logging
        postRequest()
    }
    
    func postRequest() {
        //TODO: refactor to move these two lines out.
        let body = "{\"udacity\": {\"username\": \"\(emailAddressTextField.text ?? "")\", \"password\": \"\(passwordTextField.text ?? "")\"}}"
        let responseType = LoginResponse.self
        
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body.data(using: .utf8)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { data, response, error in
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(responseType.self, from: newData!)
                print("in do")
                print(response.account)
                if response.account.key != "" {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    }
                }
            }
            catch {
                print("unable to decode response")
                // this part isn't working, need to figure out why
                DispatchQueue.main.async {
                    self.showLoginFailure(message: "Invalid credentials")
                }
                return
            }
            
        }
        task.resume()
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
}
