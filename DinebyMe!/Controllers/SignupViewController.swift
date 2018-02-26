//
//  SignupViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 14-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
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
    }
    
    func storeUserData(userId: String) {
        Database.database().reference().child("users").child(userId).setValue([
            "email": emailTextField.text,
            "name": yournameTextField.text,
            "uid": Auth.auth().currentUser?.uid])
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        return
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
}
