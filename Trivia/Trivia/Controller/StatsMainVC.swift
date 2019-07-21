//
//  StatsMainVC.swift
//  Trivia
//
//  Created by Sam Rich on 7/20/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class StatsMainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var bestCategoryLabel: UILabel!
    @IBOutlet weak var worseCategoryLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var dataController: DataController!
    var categoriesToDisplay: [LocalCategory]!
    var scores: [Int] = []
    var selectedCategory: LocalCategory!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Stats"
        getCategories()
        getCorrectScores()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        setBestCategory()
        setWorseCategory()
    }
    
    func getCategories() {
        let fetchRequest:NSFetchRequest<LocalCategory> = LocalCategory.fetchRequest()
        do {
            let fetchedCategories = try dataController.viewContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [LocalCategory]
            categoriesToDisplay = fetchedCategories
        } catch {
            fatalError("Failed to fetch category: \(error)")
        }
    }
    
    func getCorrectScores() {
        for c in categoriesToDisplay {
            let correct = c.questions!.filtered(
                using: NSPredicate(format: "didAnswerCorrectly = true")
            )
            scores.append(correct.count)
        }
    }
    
    func setBestCategory() {
        let maxElement = scores.max() ?? 0
        let maxIndex = scores.firstIndex(of: maxElement)
        // TOOD: remove force unwrap here
        bestCategoryLabel.text = categoriesToDisplay[maxIndex ?? 0].name
    }
    
    func setWorseCategory() {
        let minElement = scores.min() ?? 0
        let minIndex = scores.firstIndex(of: minElement)
        // TOOD: remove force unwrap here
        worseCategoryLabel.text = categoriesToDisplay[minIndex ?? 0].name
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryStatsCell")!
        let category = self.categoriesToDisplay[(indexPath as NSIndexPath).row]
        let score = self.scores[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = category.name
        cell.detailTextLabel?.text = "\(score) / \(category.questions!.count)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = self.categoriesToDisplay[(indexPath as NSIndexPath).row]
        selectedCategory = category
        performSegue(withIdentifier: "showQuestions", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQuestions" {
            let questionListVC = segue.destination as! QuestionListVC
            questionListVC.dataController = dataController
            questionListVC.category = selectedCategory
        }
    }
}
