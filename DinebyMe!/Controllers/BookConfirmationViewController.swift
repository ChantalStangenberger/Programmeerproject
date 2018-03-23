//
//  BookConfirmationViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 15-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
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
    @IBOutlet weak var recipecuisineLabel: UILabel!
    @IBOutlet weak var eventtimeLabel: UILabel!
    
    
    let dataStorage = DataStorage()
    let databaseReference = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmationButton.layer.cornerRadius = 4
        
        getUserData()
    }
    
    // updates scene
    func updateUI() {
        recipenameLabel.text = "    \u{2022} Recipe name: " + dataStorage.sharedInstance.recipename
        recipepriceLabel.text = "    \u{2022} Event price: " + dataStorage.sharedInstance.recipeprice
        eventdateLabel.text = "    \u{2022} Event date: " + dataStorage.sharedInstance.recipedate
        recipecuisineLabel.text = "    \u{2022} Recipe cuisine: " + dataStorage.sharedInstance.recipecuisine
        eventtimeLabel.text = "    \u{2022} Event time: " + dataStorage.sharedInstance.repicetime
    }
    
    func getUserData() {
        databaseReference.child("users").child(dataStorage.sharedInstance.id).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? String
            self.textfieldinformationLabel.text = "Food host: " + value!
            self.textfieldinformationLabel.addBottomBorderWithColor(color: UIColor.darkGray, width: 2)
        })
        updateUI()
    }
    
    @IBAction func confirmationButtonTapped(_ sender: Any) {
        
        databaseReference.child("Booking").queryOrdered(byChild: "Image").queryEqual(toValue: self.dataStorage.sharedInstance.image).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                let alert = UIAlertController(title: "Whoops!", message: "You already booked this event!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK",
                                             style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                let key = self.databaseReference.childByAutoId().key
                
                self.databaseReference.child("Booking").child(key).setValue([
                    "Recipename": self.dataStorage.sharedInstance.recipename,
                    "Recipecuisine": self.dataStorage.sharedInstance.recipecuisine,
                    "Eventprice": self.dataStorage.sharedInstance.recipeprice,
                    "Eventdate": self.dataStorage.sharedInstance.recipedate,
                    "Eventtime": self.dataStorage.sharedInstance.repicetime,
                    "Eventlatitude": self.dataStorage.sharedInstance.latitude,
                    "Eventlongitude": self.dataStorage.sharedInstance.longitude,
                    "Image": self.dataStorage.sharedInstance.image,
                    "Hostid": self.dataStorage.sharedInstance.id,
                    "Uderid": Auth.auth().currentUser?.uid as Any])
                
                let alert = UIAlertController(title: "Booking complete", message: "Now you only have to wait for acceptance of the host", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK",
                                             style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
}
