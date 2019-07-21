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

    @IBOutlet weak var multipleChoiceSwitch: UISwitch!
    @IBOutlet weak var trueFalseSwitch: UISwitch!
    @IBOutlet weak var difficultySegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        setUserUIValues()
    }
    
    func setUserUIValues() {
        difficultySegment.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "difficultyLevel")
        multipleChoiceSwitch.isOn = UserDefaults.standard.bool(forKey: "multipleChoiceEnabled")
        trueFalseSwitch.isOn = UserDefaults.standard.bool(forKey: "trueFalseEnabled")
    }
    
    @IBAction func difficultySelected(_ sender: Any) {
        UserDefaults.standard.set(difficultySegment.selectedSegmentIndex, forKey: "difficultyLevel")
    }
    
    @IBAction func multipleChoiceSwitched(_ sender: Any) {
        UserDefaults.standard.set(multipleChoiceSwitch.isOn, forKey: "multipleChoiceEnabled")
    }
    
    @IBAction func trueFalseSwitched(_ sender: Any) {
        UserDefaults.standard.set(trueFalseSwitch.isOn, forKey: "trueFalseEnabled")
    }
    
}
