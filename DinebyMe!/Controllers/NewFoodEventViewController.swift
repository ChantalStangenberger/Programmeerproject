//
//  NewFoodEventViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 15-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import UIKit

class NewFoodEventViewController: UIViewController {

    @IBOutlet weak var docorLabel: UILabel!
    @IBOutlet weak var recipenameTextField: UITextField!
    @IBOutlet weak var recipecuisineTextField: UITextField!
    @IBOutlet weak var recipepriceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        docorLabel.addBottomBorderWithColor(color: UIColor.darkGray, width: 3)
        recipenameTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        recipecuisineTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        recipepriceTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
    }
}
