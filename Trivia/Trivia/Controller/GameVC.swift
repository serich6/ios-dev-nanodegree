//
//  GameVC.swift
//  Trivia
//
//  Created by Sam Rich on 7/20/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation
import UIKit

class GameVC: UIViewController {
    var questions: [Question]!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var questionCounterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Game"
        questionTextView.text = questions.first?.question
        questionCounterLabel.text = "Question 1/\(questions.count)"
    }
    
    
}
