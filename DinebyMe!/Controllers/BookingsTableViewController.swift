//
//  BookingsTableViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 15-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import UIKit
import Firebase

class BookingsTableViewController: UITableViewController {
    
    @IBAction func signoutButtonTapped(_ sender: AnyObject) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "signoutSegue", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
