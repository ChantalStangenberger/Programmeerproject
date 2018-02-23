//
//  LoginViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 14-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
// http://www.phoumangkor.com/2017/02/how-to-custom-border-line-on-bottom-of.html
//

import UIKit
import Firebase
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var changepasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        passwordTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        loginButton.layer.cornerRadius = 4
        cancelButton.layer.cornerRadius = 4
        
        let facebookloginButton = UIButton(frame: CGRect(x: 65, y: 140, width: 80, height: 80))
        let facebookimage = UIImage(named: "facebookbutton")
        facebookloginButton.setImage(facebookimage, for: .normal)
        facebookloginButton.addTarget(self, action: #selector(self.facebookloginButtonTapped), for: .touchUpInside)
        
        let googleloginButton = UIButton(frame: CGRect(x: 235, y: 143, width: 75, height: 75))
        let googleimage = UIImage(named: "googlebutton")
        googleloginButton.setImage(googleimage, for: .normal)
        
        view.addSubview(facebookloginButton)
        view.addSubview(googleloginButton)
    }
    
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
                        currentUser = Auth.auth().currentUser
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
    
    @IBAction func loginButtonTapped(_ sender: AnyObject) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            UIView.animate(withDuration: 0.5, animations: {
                let rightTransform  = CGAffineTransform(translationX: 40, y: 0)
                self.emailTextField.transform = rightTransform
                self.passwordTextField.transform = rightTransform
                
            }) { (_) in
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.emailTextField.transform = CGAffineTransform.identity
                    self.passwordTextField.transform = CGAffineTransform.identity
                })
            }
        } else {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Whoops!", message: "Incorrect email or password", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK",
                    style: .default)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.performSegue(withIdentifier: "loginhomeSegue", sender: self)
                }
            }
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: AnyObject) {
        return
    }
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
}

extension UIView {
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
}
