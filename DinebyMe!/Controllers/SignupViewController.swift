//
//  SignupViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 14-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
//  Allows the user to create an account for DinebyMe!.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var yournameTextField: UITextField! = nil
    @IBOutlet weak var emailTextField: UITextField! = nil
    @IBOutlet weak var passwordTextField: UITextField! = nil
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var designLabel: UILabel!
    @IBOutlet weak var designLabel2: UILabel!
    
    // Set up view with some preferences.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        passwordTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        yournameTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        registerButton.layer.cornerRadius = 4
        cancelButton.layer.cornerRadius = 4
        designLabel.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        designLabel2.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        yournameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // checks if emailfield and passwordfield are filled in and calls function createUser.
    @IBAction func registerButtonTapped(_ sender: AnyObject) {
        if yournameTextField.text == "" || emailTextField.text == "" || passwordTextField.text == "" {
            UIView.animate(withDuration: 0.5, animations: {
                let rightTransform  = CGAffineTransform(translationX: 30, y: 0)
                self.yournameTextField.transform = rightTransform
                self.emailTextField.transform = rightTransform
                self.passwordTextField.transform = rightTransform
                
            }) { (_) in
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.yournameTextField.transform = CGAffineTransform.identity
                    self.emailTextField.transform = CGAffineTransform.identity
                    self.passwordTextField.transform = CGAffineTransform.identity
                })
            }
        } else {
            createUser()
        }
    }
    
    // Creates user in firebase if there's no conflict with firebase.
    func createUser() {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error == nil {
                self.storeUserData(userId: (user?.uid)!)
                Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!)
                self.performSegue(withIdentifier: "signuphomeSegue", sender: self)
            } else {
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    
                    switch(errorCode) {
                    case .invalidEmail:
                        let alert = UIAlertController(title: "Something went wrong", message: "This email address does not exist", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK",
                                                     style: .default)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    case .emailAlreadyInUse:
                        let alert = UIAlertController(title: "Something went wrong", message: "Email address is already in use", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK",
                                                     style: .default)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    case .weakPassword:
                        let alert = UIAlertController(title: "Something went wrong", message: "Password is to weak", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK",
                                                     style: .default)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    default:
                        let alert = UIAlertController(title: "Something went wrong", message: "Try again to register", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK",
                                                     style: .default)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    // creates path in database with unique userid and email.
    func storeUserData(userId: String) {
        Database.database().reference().child("users").child(userId).setValue([
            "email": emailTextField.text,
            "name": yournameTextField.text,
            "uid": Auth.auth().currentUser?.uid])
    }

    // Go to the login page.
    @IBAction func cancelButtonTapped(_ sender: Any) {
        return
    }
    
    // When return is pressed, keyboard disappears.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    // When clicked somewhere on the screen, keyboard disappears.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
}
