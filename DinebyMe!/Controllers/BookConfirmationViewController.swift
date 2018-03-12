//
//  BookConfirmationViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 15-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import UIKit

class BookConfirmationViewController: UIViewController {

    @IBOutlet weak var recipenameLabel: UILabel!
    @IBOutlet weak var eventdateLabel: UILabel!
    @IBOutlet weak var recipepriceLabel: UILabel!
    @IBOutlet weak var priceinformationLabel: UILabel!
    @IBOutlet weak var textfieldinformationLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var confirmationButton: UIButton!
    
    let dataStorage = DataStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipenameLabel.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        eventdateLabel.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        recipepriceLabel.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        textfieldinformationLabel.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        messageTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        confirmationButton.layer.cornerRadius = 4
        
        updateUI()
        
    }
    
    // updates scene
    func updateUI() {
        recipenameLabel.text = dataStorage.sharedInstance.recipename
        recipepriceLabel.text = dataStorage.sharedInstance.recipeprice
        eventdateLabel.text = dataStorage.sharedInstance.recipedate
        textfieldinformationLabel.text = dataStorage.sharedInstance.id
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
