//
//  QuestionListVC.swift
//  Trivia
//
//  Created by Sam Rich on 7/21/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class QuestionListVC: UIViewController {
    @IBOutlet weak var questionTextLabel: UITextView!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var yourAnswerLabel: UILabel!
    var dataController: DataController!
    var category: LocalCategory!
    var questionsToDisplay: [LocalQuestion]!
    
    override func viewDidLoad() {
        questionTextLabel.text = "Select a question from the list below for review."
        correctAnswerLabel.isHidden = true
        yourAnswerLabel.isHidden = true
        getQuestions()
    }
    
    func getQuestions() {
        let fetchRequest:NSFetchRequest<LocalQuestion> = LocalQuestion.fetchRequest()
        let predicateString = "belongsToCategory = %@"
        fetchRequest.predicate = NSPredicate(format: predicateString, category)
        do {
            let fetchedQuestions = try dataController.viewContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [LocalQuestion]
            questionsToDisplay = fetchedQuestions
            print(questionsToDisplay)
        } catch {
            fatalError("Failed to fetch category: \(error)")
        }
    }
}
