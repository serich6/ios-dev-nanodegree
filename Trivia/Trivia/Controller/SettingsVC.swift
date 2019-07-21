//
//  SettingsVC.swift
//  Trivia
//
//  Created by Sam Rich on 7/20/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation
import UIKit

class SettingsVC: UIViewController {
    
    @IBOutlet weak var difficultySlider: UISlider!
    @IBOutlet weak var multipleChoiceSwitch: UISwitch!
    @IBOutlet weak var trueFalseSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // todo: update nav bar title to Game Settings
    }
    
}
