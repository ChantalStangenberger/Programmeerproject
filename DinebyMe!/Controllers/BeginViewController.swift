//
//  BeginViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 14-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import UIKit
import Firebase

class BeginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBAction func loginButtonTapped(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "loginSegue", sender: self)
    }
    
    @IBAction func signupButtonTapped(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "signupSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 4
        signupButton.layer.cornerRadius = 4
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                    self.performSegue(withIdentifier: "homeSegue", sender: nil)
            }
        }
        
    }
}
