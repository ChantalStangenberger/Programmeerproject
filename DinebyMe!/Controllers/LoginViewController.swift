//
//  LoginViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 14-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
//  Allows the user to log in into DinebyMe! with facebook or email or go to the email sign up page.
//  User can also reset their password.
//  For layout preferences: http://www.phoumangkor.com/2017/02/how-to-custom-border-line-on-bottom-of.html
//

import UIKit
import Firebase
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField! = nil
    @IBOutlet weak var passwordTextField: UITextField! = nil
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var changepasswordButton: UIButton!
    @IBOutlet weak var registeraccountButton: UIButton!
    
    // Set up view with some preferences.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        passwordTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        loginButton.layer.cornerRadius = 4
        cancelButton.layer.cornerRadius = 4
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let facebookloginButton = UIButton(frame: CGRect(x: 150, y: 110, width: 80, height: 80))
        let facebookimage = UIImage(named: "facebookbutton")
        facebookloginButton.setImage(facebookimage, for: .normal)
        facebookloginButton.addTarget(self, action: #selector(self.facebookloginButtonTapped), for: .touchUpInside)
        
        view.addSubview(facebookloginButton)
    }
    
    // Facebook login option with loginmanager.
    @objc func facebookloginButtonTapped() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) {loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, _, let accessToken):
                if grantedPermissions.contains("email") {
                    facebookAccesToken = accessToken
                    let credential = FacebookAuthProvider.credential(withAccessToken: (facebookAccesToken?.authenticationToken)!)
                    Auth.auth().signIn(with: credential) { (user, error) in
                        if error != nil {
                            let alert = UIAlertController(title: "Error", message: "Something went wrong while signing in!", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK",
                                                         style: .default)
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                        }
                        self.storeUserData(userId: (user?.uid)!)
                        self.performSegue(withIdentifier: "loginhomeSegue", sender: self)
                    }
                } else {
                    let alert = UIAlertController(title: "Error while getting email address permission!", message: "DinebyMe! needs your email address for optimal application experience", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK",
                                                 style: .default)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // Creates path in database with facebook and name from facebook data and an unique userid.
    func storeUserData(userId: String) {
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "name, email"])) { httpResponse, result in
            switch result {
            case .success(let response):
                Database.database().reference().child("users").child(userId).setValue([
                    "uid": Auth.auth().currentUser?.uid,
                    "email": response.dictionaryValue?["email"],
                    "name": response.dictionaryValue?["name"]])
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }
    
    // Checks if emailfield and passwordfield are filled in: if user exists in firebase log in to DinebyMe!
    @IBAction func loginButtonTapped(_ sender: AnyObject) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            UIView.animate(withDuration: 0.5, animations: {
                let rightTransform  = CGAffineTransform(translationX: 30, y: 0)
                self.emailTextField.transform = rightTransform
                self.passwordTextField.transform = rightTransform
                
            }) { (_) in
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.emailTextField.transform = CGAffineTransform.identity
                    self.passwordTextField.transform = CGAffineTransform.identity
                })
            }
        } else {
            signinFirebase()
        }
    }
    
    // Sign user in into firebase.
    func signinFirebase() {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    
                    switch(errorCode) {
                    case .userNotFound:
                        let alert = UIAlertController(title: "Something went wrong", message: "User was not found in our database, please register", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK",
                                                     style: .default)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    case .wrongPassword:
                        let alert = UIAlertController(title: "Something went wrong", message: "Wrong password", preferredStyle: .alert)
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
                
            } else {
                self.performSegue(withIdentifier: "loginhomeSegue", sender: self)
            }
        }
    }
    
    // Go to the beginscreen.
    @IBAction func cancelButtonTapped(_ sender: AnyObject) {
        return
    }
    
    // When a user forgot his password, a reset link can be send.
    @IBAction func changepasswordButtonTapped(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Forgot password", message: "Please enter your email address and we will send you a reset link.", preferredStyle: .alert)
        
        let sendAction = UIAlertAction(title: "Send link", style: .default) { action in
            let emailField = alert.textFields![0]
                    Auth.auth().sendPasswordReset(withEmail: emailField.text!) { (error) in
                        if error != nil {
                            let alert = UIAlertController(title: "Error while sending password reset email", message: "This email address is not linked to an account.", preferredStyle: .alert)
                            let okeAction = UIAlertAction(title: "Ok",
                                                          style: .default)
                            alert.addAction(okeAction)
                            self.present(alert, animated: true, completion: nil)
                        } 
                    }
        }
        
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .default)
            
            alert.addTextField { textEmail in
                textEmail.placeholder = "Enter your email address"
            }
            
            alert.addAction(sendAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
    }
    
    // Go to the register page.
    @IBAction func registeraccountButtonTapped(_ sender: AnyObject) {
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

// Allows to customize the bottom border.
extension UIView {
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
}
