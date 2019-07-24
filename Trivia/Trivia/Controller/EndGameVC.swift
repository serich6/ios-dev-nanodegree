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
    var winLoseLabelText: String!
    var scoreLabelText: String!
    var dataController:DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        winLoseLabel.text = winLoseLabelText
        scoreLabel.text = scoreLabelText
    }
    
    @IBAction func doneButtonClicked() {
        performSegue(withIdentifier: "exitEndGameScreen", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exitEndGameScreen" {
            let triviaMainVC = segue.destination as! TriviaMainVC
            triviaMainVC.dataController = dataController
        }
    }
}
