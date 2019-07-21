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
    @IBOutlet weak var nextButton: UIButton!
    var currentQuestion: Question!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Game"
        currentQuestion = questions.first!
        displayQuestion()
        questionCounterLabel.text = "Question 1/\(questions.count)"
        resetButtonBGs()
    }
    
    func displayAnswerChoices() {
        // add all of the answers to an array and display them randomly (so we don't have the correct answer in the same place all the time)
        toggleAnswerButtons(enabled: true)
        nextButton.isHidden = true
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
        toggleAnswerButtons(enabled: false)
        nextButton.isHidden = false
        // TODO: remove force unwrap
        let selectedAnswer = button.titleLabel!.text
        if selectedAnswer == currentQuestion.correctAnswer {
            print("that's correct!")
            button.backgroundColor = UIColor.green
        } else {
            button.backgroundColor = UIColor.red
            print("That's not right, looking for \(currentQuestion.correctAnswer)")
        }
        
        // disable the buttons
        
        // if correct -> hightlight that text in green
        // if wrong -> highlight the correct answer in green, selected in red
        // don't forget to reset for next question
        
    }
    
    func toggleAnswerButtons (enabled: Bool){
        answer1.isEnabled = enabled
        answer2.isEnabled = enabled
        answer3.isEnabled = enabled
        answer4.isEnabled = enabled
    }
    
    func resetButtonBGs() {
        answer1.backgroundColor = UIColor.blue
        answer2.backgroundColor = UIColor.blue
        answer3.backgroundColor = UIColor.blue
        answer4.backgroundColor = UIColor.blue
    }
    
    
}
