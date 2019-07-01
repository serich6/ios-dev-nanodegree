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
    
    @IBAction func clickRefreshButton(_ sender: Any) {
        print("clicked logout")
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
        let alertVC = UIAlertController(title: "User Pin Exists", message: "A pin already exists for your user and current session. Press OK to overwrite the current pin.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func handleOverwrite() {
        print("reached handle overwrite method")
         // if accept alert, bring up new view,
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataModel.pinData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // From course instructions/examples
        let cell = tableView.dequeueReusableCell(withIdentifier: "pinCell")!
        let displayName = "\(DataModel.pinData[(indexPath as NSIndexPath).row].firstName) \(DataModel.pinData[(indexPath as NSIndexPath).row].lastName)"
        cell.textLabel?.text = displayName
        cell.imageView?.image = UIImage(named:"icon_pin")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "tableCellDetailSegue", sender: nil)
    }


}

