//
//  AddPinVC.swift
//  On The Map
//
//  Created by Sam Rich on 6/15/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation
import UIKit

class AddPinVC: UIViewController {
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func findButtonClicked(_ sender: Any) {
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
         performSegue(withIdentifier: "returnToTabView", sender: nil)
        
    }
    
}
