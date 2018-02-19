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

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        passwordTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        loginButton.layer.cornerRadius = 4
        cancelButton.layer.cornerRadius = 4
        
        let facebookloginButton = LoginButton(readPermissions: [ .publicProfile ])
        facebookloginButton.center = view.center
        
        view.addSubview(facebookloginButton)
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
        self.performSegue(withIdentifier: "cancelloginSegue", sender: nil)
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
