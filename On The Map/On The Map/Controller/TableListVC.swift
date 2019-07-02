//
//  SecondViewController.swift
//  On The Map
//
//  Created by Sam Rich on 5/29/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import UIKit

class TableListVC: UITableViewController {

    @IBOutlet weak var pinButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    var isPost: Bool!
    
    // TODO: on initial load, nothing is there, but hitting the refresh button solves the issue.
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = PinClient.getPins() { pins, error in
            DataModel.pinData = pins!
            // self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func clickLogoutButton(_ sender: Any) {
        UdacityClient.logoutRequest(completion: handleLogOut(bool:error:))
    }
    
    func handleLogOut(bool: Bool, error: Error?){
        DispatchQueue.main.async {
            if bool {
                self.dismiss(animated: true, completion: nil)
            } else {
                print(error)
            }
        }
    }
    
    @IBAction func clickPinButton(_ sender: Any) {
       PinClient.getUsersPin(completion: handleCheckForUserPin(bool:error:))
    }
    
    func handleCheckForUserPin(bool: Bool, error: Error?) {
         DispatchQueue.main.async {
            if bool {
                    self.showOverwritePinPrompt()
            } else {
                self.performSegue(withIdentifier: "addPinFromTableSegue", sender: nil)
            }
        }
    }
    
    func showOverwritePinPrompt() {
        let alert = UIAlertController(title: "Pin for user already exists", message: "You have already created a pin. Would you like to overwrite it?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: handleOverwrite))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleOverwrite(action: UIAlertAction) {
        isPost = false
        performSegue(withIdentifier: "addPinFromTableSegue", sender: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataModel.pinData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // From course instructions/examples and MemeMe
        let cell = tableView.dequeueReusableCell(withIdentifier: "pinCell")!
        let displayName = "\(DataModel.pinData[(indexPath as NSIndexPath).row].firstName) \(DataModel.pinData[(indexPath as NSIndexPath).row].lastName)"
        cell.textLabel?.text = displayName
        cell.imageView?.image = UIImage(named:"icon_pin")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "pinCell")!
        let urlString = DataModel.pinData[(indexPath as NSIndexPath).row].mediaURL
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }


}

