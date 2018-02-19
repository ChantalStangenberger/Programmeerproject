//
//  HomeViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 15-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBAction func buttonTapped(_ sender: AnyObject) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "SignOutSegue", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
