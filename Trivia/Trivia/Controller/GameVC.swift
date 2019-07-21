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
    @IBOutlet weak var answer1: UIButton!
    @IBOutlet weak var answer2: UIButton!
    @IBOutlet weak var answer3: UIButton!
    @IBOutlet weak var answer4: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Game"
        // TODO: remove force unwrap here
        displayQuestion(question: questions.first!)
        questionCounterLabel.text = "Question 1/\(questions.count)"
    }
    
    func displayAnswerChoices(question: Question) {
        // add all of the answers to an array and display them randomly (so we don't have the correct answer in the same place all the time)
        var answerSet = question.incorrectAnswers
        answerSet.append(question.correctAnswer)
        answerSet = answerSet.shuffled()
        answer1.setTitle(answerSet[0], for: .normal)
        answer2.setTitle(answerSet[1], for: .normal)
        if question.type == "multiple" {
            answer3.setTitle(answerSet[2], for: .normal)
            answer4.setTitle(answerSet[3], for: .normal)
        } else {
            answer3.isHidden = true
            answer4.isHidden = true
        }
    }
    
    func displayQuestion(question: Question) {
        questionTextView.text = question.question
        displayAnswerChoices(question: question)
    }
    
    
}
