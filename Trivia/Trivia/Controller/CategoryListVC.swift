//
//  CategoryListVC.swift
//  Trivia
//
//  Created by Sam Rich on 7/20/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CategoryListVC: UITableViewController {
    var categoryList: [Category]!
    var fetchedQuestions: [Question]!
    var selectedCategory: Category!
    var dataController:DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Category"
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")!
        let category = self.categoryList[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = "\(category.name)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = self.categoryList[(indexPath as NSIndexPath).row]
        selectedCategory = category
        OpenDBClient.getQuestions(category: category.id, completion: handleGetQuestionsResponse(questions:error:))
    }
    
    func handleGetQuestionsResponse(questions: [Question]?, error: Error?) {
        DispatchQueue.main.async {
            if error != nil {
                self.showGetQuestionsErrorAlert(message: error?.localizedDescription ?? "There was an issue downloading the questions, please try again.")
            } else {
                self.fetchedQuestions = questions
                self.performSegue(withIdentifier: "showGame", sender: nil)
            }
        }
    }
    
    func showGetQuestionsErrorAlert(message: String) {
        let alert = UIAlertController(title: "Fetch questions error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkForCategoryInCoreData(id: Int) -> Bool {
        let fetchRequest:NSFetchRequest<LocalCategory> = LocalCategory.fetchRequest()
        let predicateString = "id = \(id)"
        fetchRequest.predicate = NSPredicate(format: predicateString)
        do {
            let fetchedCategories = try dataController.viewContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [LocalCategory]
            return fetchedCategories.count > 0
        } catch {
            fatalError("Failed to fetch category: \(error)")
        }
    }
    
    func addCategoryToCoreData(category: Category) {
       let exists = checkForCategoryInCoreData(id: category.id)
        if exists {
            print("Category \(category.name) already created in core data. Continuing")
        } else {
            print("Adding category: \(category.name)")
            let categoryToSave = LocalCategory(context: dataController.viewContext)
            categoryToSave.name = category.name
            categoryToSave.id = "\(category.id)"
            try? dataController.viewContext.save()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGame"{
            let gameVC = segue.destination as! GameVC
            gameVC.questions = fetchedQuestions
            gameVC.selectedCategory = selectedCategory
            gameVC.dataController = dataController
            addCategoryToCoreData(category: selectedCategory)
        }
    }
    
}
