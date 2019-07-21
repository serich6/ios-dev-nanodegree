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
        if !multipleChoiceSwitch.isOn && !trueFalseSwitch.isOn{
            multipleChoiceSwitch.isOn = true
            showAllDisabledAlert()
        } else {
            UserDefaults.standard.set(multipleChoiceSwitch.isOn, forKey: "multipleChoiceEnabled")
        }
    }
    
    @IBAction func trueFalseSwitched(_ sender: Any) {
        if !multipleChoiceSwitch.isOn && !trueFalseSwitch.isOn {
            trueFalseSwitch.isOn = true
            showAllDisabledAlert()
        } else {
           UserDefaults.standard.set(trueFalseSwitch.isOn, forKey: "trueFalseEnabled")
        }
    }
    func showAllDisabledAlert() {
        let alert = UIAlertController(title: "Uh oh!", message: "At least one question type must be toggled on.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
