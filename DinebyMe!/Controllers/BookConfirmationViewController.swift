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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipenameLabel.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        eventdateLabel.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        recipepriceLabel.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        textfieldinformationLabel.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        messageTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        confirmationButton.layer.cornerRadius = 4
        
    }
}
