//
//  EndGame.swift
//  Trivia
//
//  Created by Sam Rich on 7/21/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation
import UIKit

class EndGameVC: UIViewController {
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var winLoseLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doneButtonClicked() {
        print("done button clicked")
        performSegue(withIdentifier: "exitEndGameScreen", sender: nil)
    }
}
