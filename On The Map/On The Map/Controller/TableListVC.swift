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
    }
    @IBAction func clickPinButton(_ sender: Any) {
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

