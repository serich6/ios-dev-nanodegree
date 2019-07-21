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
        print(categoryList)
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
        cell.textLabel?.text = "\(category.name ?? "Category Name Unavailable")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "tableCellDetailSegue", sender: nil)
        print("cell has been tapped")
    }
    
    
}
