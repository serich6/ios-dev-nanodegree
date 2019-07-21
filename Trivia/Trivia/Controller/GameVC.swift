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
    @IBOutlet weak var exitButton: UIButton!
    var currentQuestion: Question!
    var currentIndex: Int = 0
    var scoredQuestions: [Question] = []
    var selectedCategory: Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Game"
        currentQuestion = questions.first!
        displayQuestion()
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func exitGame() {
        print("exit game button clicked")
        // TOOD: get the nav to go back to the initial page
    }
    
    
    
    func displayAnswerChoices() {
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
        questionCounterLabel.text = "Question \(currentIndex + 1)/\(questions.count)"
        resetButtons()
        questionTextView.text = currentQuestion.question
        displayAnswerChoices()
    }
    
    @IBAction func nextButtonClicked() {
        if currentIndex < questions.count - 1 {
            currentIndex = currentIndex + 1
            currentQuestion = questions[currentIndex]
            displayQuestion()
        } else {
            performSegue(withIdentifier: "showEndGame", sender: nil)
        }
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
            button.backgroundColor = UIColor.green
        } else {
            button.backgroundColor = UIColor.red
            let correctButton = findCorrectAnswerButton(answer: currentQuestion.correctAnswer)
            correctButton.backgroundColor = UIColor.green
            correctButton.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    func findCorrectAnswerButton(answer: String) -> UIButton {
        if answer1.titleLabel!.text == answer {
            return answer1
        } else if answer2.titleLabel!.text == answer {
            return answer1
        } else if answer3.titleLabel!.text == answer {
            return answer1
        } else {
            return answer4
        }
    }
    
    func toggleAnswerButtons (enabled: Bool){
        answer1.isEnabled = enabled
        answer2.isEnabled = enabled
        answer3.isEnabled = enabled
        answer4.isEnabled = enabled
    }
    
    func resetButtons() {
        toggleAnswerButtons(enabled: true)
        answer1.backgroundColor = UIColor.blue
        answer2.backgroundColor = UIColor.blue
        answer3.backgroundColor = UIColor.blue
        answer4.backgroundColor = UIColor.blue
        answer1.setTitleColor(UIColor.white, for: .normal)
        answer2.setTitleColor(UIColor.white, for: .normal)
        answer3.setTitleColor(UIColor.white, for: .normal)
        answer4.setTitleColor(UIColor.white, for: .normal)
    }
}
