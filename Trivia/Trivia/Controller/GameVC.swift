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
    var currentQuestion: Question!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Game"
        currentQuestion = questions.first!
        displayQuestion()
        questionCounterLabel.text = "Question 1/\(questions.count)"
    }
    
    func displayAnswerChoices() {
        // add all of the answers to an array and display them randomly (so we don't have the correct answer in the same place all the time)
        var answerSet = currentQuestion.incorrectAnswers
        answerSet.append(currentQuestion.correctAnswer)
        answerSet = answerSet.shuffled()
        answer1.setTitle(answerSet[0], for: .normal)
        answer2.setTitle(answerSet[1], for: .normal)
        if currentQuestion.type == "multiple" {
            answer3.setTitle(answerSet[2], for: .normal)
            answer4.setTitle(answerSet[3], for: .normal)
        } else {
            answer3.isHidden = true
            answer4.isHidden = true
        }
    }
    
    func displayQuestion() {
        questionTextView.text = currentQuestion.question
        displayAnswerChoices()
    }
    
    @IBAction func checkAnswer(sender: AnyObject) {
        guard let button = sender as? UIButton else {
            return
        }
        // TODO: remove force unwrap
        var selectedAnswer = button.titleLabel!.text
        if selectedAnswer == currentQuestion.correctAnswer {
            print("that's correct!")
        } else {
            print("That's not right, looking for \(currentQuestion.correctAnswer)")
        }
    }
    
    
}
