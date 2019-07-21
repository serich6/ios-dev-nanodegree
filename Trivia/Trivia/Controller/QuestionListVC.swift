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

class QuestionListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var questionTextLabel: UITextView!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var yourAnswerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var dataController: DataController!
    var category: LocalCategory!
    var questionsToDisplay: [LocalQuestion]!
    
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
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
        } catch {
            fatalError("Failed to fetch category: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell")!
        let question = self.questionsToDisplay[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = question.text
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let question = self.questionsToDisplay[(indexPath as NSIndexPath).row]
        print("selected a quetsion")
        questionTextLabel.text = question.text
        yourAnswerLabel.text = question.yourAnswer
        yourAnswerLabel.isHidden = false
        correctAnswerLabel.text = question.correctAnswer
        correctAnswerLabel.isHidden = false
    }
}
