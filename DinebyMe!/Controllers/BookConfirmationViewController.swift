//
//  BookConfirmationViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 15-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
//  https://nickharris.wordpress.com/2016/09/11/limiting-the-number-of-lines-in-a-uitextview/
//

import UIKit
import Firebase

class BookConfirmationViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var recipenameLabel: UILabel!
    @IBOutlet weak var eventdateLabel: UILabel!
    @IBOutlet weak var recipepriceLabel: UILabel!
    @IBOutlet weak var priceinformationLabel: UILabel!
    @IBOutlet weak var textfieldinformationLabel: UILabel!
    @IBOutlet weak var confirmationButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    
    
    let dataStorage = DataStorage()
    let databaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextView.layer.borderWidth = 1
        confirmationButton.layer.cornerRadius = 4
        
        messageTextView.delegate = self
        messageTextView.textContainer.maximumNumberOfLines = 4
        messageTextView.textContainer.lineBreakMode = .byTruncatingTail
        
        getUserData()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        messageTextView.text = ""
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let existingLines = textView.text.components(separatedBy: CharacterSet.newlines)
        let newLines = text.components(separatedBy: CharacterSet.newlines)
        let linesAfterChange = existingLines.count + newLines.count - 1
        
        return linesAfterChange <= textView.textContainer.maximumNumberOfLines
    }
    
    // updates scene
    func updateUI() {
        recipenameLabel.text = "    \u{2022} Naam recept: " + dataStorage.sharedInstance.recipename
        recipepriceLabel.text = "    \u{2022} Prijs recept: " + dataStorage.sharedInstance.recipeprice
        eventdateLabel.text = "    \u{2022} Datum evenement: " + dataStorage.sharedInstance.recipedate
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
    
    func getUserData() {
        databaseReference.child("users").child(dataStorage.sharedInstance.id).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? String
            self.textfieldinformationLabel.text = "Food host: " + value!
        })
        updateUI()
    }
}
