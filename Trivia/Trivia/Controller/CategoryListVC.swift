//
//  CategoryListVC.swift
//  Trivia
//
//  Created by Sam Rich on 7/20/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation
import UIKit

class CategoryListVC: UITableViewController {
    var categoryList: [Category]!
    
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
        // From course instructions/examples
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")!
        let category = self.categoryList[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = "\(category.name)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        OpenDBClient.getQuestions(completion: handleGetQuestionsResponse(questions:error:))
    }
    
    func handleGetQuestionsResponse(questions: [Question]?, error: Error?) {
        DispatchQueue.main.async {
            if error != nil {
                self.showGetQuestionsErrorAlert(message: error?.localizedDescription ?? "There was an issue downloading the questions, please try again.")
            } else {
                print(questions)
                self.performSegue(withIdentifier: "showGame", sender: nil)
            }
        }
    }
    
    func showGetQuestionsErrorAlert(message: String) {
        let alert = UIAlertController(title: "Fetch questions error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
