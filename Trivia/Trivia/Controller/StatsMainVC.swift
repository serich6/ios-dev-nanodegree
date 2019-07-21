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
        bestCategoryLabel.text = categoriesToDisplay.first?.name
    }
    
    func setWorseCategory() {
        worseCategoryLabel.text = categoriesToDisplay.last?.name
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
        var percentage = 0
        // Handle divide by zero issue
        if category.questions!.count > 0 {
            percentage = score/category.questions!.count
        }
        
        // TODO: move the score portion to the right justified position
        cell.textLabel?.text = category.name! + " \(score) / \(category.questions!.count)"
        //cell.detailTextLabel?.text = "\(score)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row tapped")
    }
}
