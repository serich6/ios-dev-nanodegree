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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //    MARK: Button Handlers
    @IBAction func clickLoginButton(_ sender: Any) {
       //for now, perform the sqgue into the app
        performSegue(withIdentifier: "loginSegue", sender: nil)
        //later
        //disahle user interaction
        //display loading icon
        //authenticate fields
        //perform segue after success
        
    }
    
}
