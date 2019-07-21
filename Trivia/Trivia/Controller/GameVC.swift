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
    
    func toggleAnswersByQuestionType(isTrueFalse: Bool){
        if isTrueFalse {
            //print("found a true false question")
            answer3.isHidden = true
            answer4.isHidden = true
        } else {
            //print("found a mc question")
            answer3.isHidden = false
            answer4.isHidden = false
        }
    }
    
    func displayAnswerChoices(question: Question) {
        // add all of the answers to an array and display them randomly (so we don't have the correct answer in the same place all the time)
        var answerSet = question.incorrectAnswers
        answerSet.append(question.correctAnswer)
        answerSet = answerSet.shuffled()
    }
    
    func displayQuestion(question: Question) {
        questionTextView.text = question.question
        toggleAnswersByQuestionType(isTrueFalse: question.type == "bool")
        displayAnswerChoices(question: question)
    }
    
    
}
