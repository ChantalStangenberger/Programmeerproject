//
//  BookingsTableViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 15-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore

var currentUser: User?

class BookingsTableViewController: UITableViewController {
    
    @IBAction func signoutButtonTapped(_ sender: AnyObject) {
        if facebookAccesToken != nil {
            AccessToken.current = nil
            facebookAccesToken = nil
        }
            
        else if currentUser != nil {
            do {
                try Auth.auth().signOut()
                currentUser = nil
                self.performSegue(withIdentifier: "signoutSegue", sender: self)
                print("Sign Out Successful")
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
