//
//  BeginViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 14-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
//  Beginscreen of DinebyMe!
//

import UIKit
import Firebase

class BeginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    // Go to the login page.
    @IBAction func loginButtonTapped(_ sender: AnyObject) {
        return
    }
    
    // If a current user is logged in, go to homescreen.
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 4
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                    self.performSegue(withIdentifier: "homeSegue", sender: nil)
            }
        }
        
    }
}

