//
//  StatsMainVC.swift
//  Trivia
//
//  Created by Sam Rich on 7/20/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation
import UIKit

class StatsMainVC: UIViewController, UITableViewDelegate {
    @IBOutlet weak var bestCategoryLabel: UILabel!
    @IBOutlet weak var worseCategoryLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Stats"
        //tableView.delegate = self
    }
    
    
}
