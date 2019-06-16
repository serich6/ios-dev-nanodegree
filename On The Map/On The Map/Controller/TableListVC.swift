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
            print("in view did load")
            print(DataModel.pinData)
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func clickRefreshButton(_ sender: Any) {
        print("clicked refresh button")
    }
    @IBAction func clickPinButton(_ sender: Any) {
        if DataModel.userAdded {
            showOverwritePinPrompt()
        }
        else {
            //need to perform the segue here, not sure why doing it conditionally is so tricky
            performSegue(withIdentifier: "addPinFromTableSegue", sender: nil)
        }
        
    }
    
    func showOverwritePinPrompt() {
        let alertVC = UIAlertController(title: "Pin already exists", message: "A pin already exists for your acount. Do you want to overwrite the existing pin?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: nil))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
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
        print(displayName)
        cell.textLabel?.text = displayName
        cell.imageView?.image = UIImage(named:"icon_pin")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "tableCellDetailSegue", sender: nil)
    }


}

