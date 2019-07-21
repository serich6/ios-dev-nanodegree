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
        // Disabling in case there is some lag so the user doesn't tap multiple times
        playGameButton.isEnabled = false
        OpenDBClient.getCategories(completion: handleGetCategoriesResponse(categories:error:))
    }
    
    func handleGetCategoriesResponse(categories: [Category]?, error: Error?) {
        if error != nil {
            showGetCategoriesErrorAlert(message: error?.localizedDescription ?? "Error downloading categories, please try again.")
        } else {
            categoriesList = categories
            DispatchQueue.main.async {
                self.playGameButton.isEnabled = true
                self.performSegue(withIdentifier: "showCategories", sender: nil)
            }
        }
    }
    
    func showGetCategoriesErrorAlert(message: String) {
        let alert = UIAlertController(title: "Fetch categories error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCategories"{
            let categoriesVC = segue.destination as! CategoryListVC
            categoriesVC.categoryList = categoriesList
        }
    }
}

