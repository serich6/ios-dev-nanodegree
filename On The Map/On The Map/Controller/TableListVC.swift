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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func clickRefreshButton(_ sender: Any) {
        print("clicked refresh button")
    }
    @IBAction func clickPinButton(_ sender: Any) {
        print("clicked refresh button")
        showOverwritePinPrompt()
        // need to check if this person already has a pin
        //if not, bring up the new view
        // if yes, bring up alert
    
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
       // return memes.count
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // From course instructions/examples
        let cell = tableView.dequeueReusableCell(withIdentifier: "pinCell")!
//        let meme = self.memes[(indexPath as NSIndexPath).row]
//        cell.textLabel?.text = "\(meme.topText ?? "top") \(meme.bottomText ?? "bottom")"
//        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "tableCellDetailSegue", sender: nil)
    }


}

