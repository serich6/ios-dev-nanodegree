//
//  ViewController.swift
//  Trivia
//
//  Created by Sam Rich on 7/20/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import UIKit

class TriviaMainVC: UIViewController {

    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var statsButton: UIButton!
    @IBOutlet weak var playGameButton: UIButton!
    var categoriesList: [Category]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.title = "Trivia"
    }
    
    @IBAction func playButtonTapped() {
        OpenDBClient.getCategories(completion: handleGetCategoriesResponse(categories:error:))
    }
    
    func handleGetCategoriesResponse(categories: [Category]?, error: Error?) {
        categoriesList = categories
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "showCategories", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCategories"{
            let categoriesVC = segue.destination as! CategoryListVC
            categoriesVC.categoryList = categoriesList
        }
    }
}

