//
//  BookConfirmationViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 15-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
//  User sees a overview of event details and can request to book a specific event.
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
    let userId = Auth.auth().currentUser?.uid

    // Set up view with some preferences and calls function getUserData.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmationButton.layer.cornerRadius = 4
        
        getUserData()
    }
    
    // Updates scene.
    func updateUI() {
        recipenameLabel.text = "    \u{2022} Recipe name: " + dataStorage.sharedInstance.recipename
        recipepriceLabel.text = "    \u{2022} Event price: " + dataStorage.sharedInstance.recipeprice
        eventdateLabel.text = "    \u{2022} Event date: " + dataStorage.sharedInstance.recipedate
        recipecuisineLabel.text = "    \u{2022} Recipe cuisine: " + dataStorage.sharedInstance.recipecuisine
        eventtimeLabel.text = "    \u{2022} Event time: " + dataStorage.sharedInstance.repicetime
    }
    
    // Gets user data to display the event host's name.
    func getUserData() {
        databaseReference.child("users").child(dataStorage.sharedInstance.id).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? String
            self.textfieldinformationLabel.text = "Event of " + value!
            self.textfieldinformationLabel.addBottomBorderWithColor(color: UIColor.darkGray, width: 2)
        })
        updateUI()
    }
    
    // Confirm booking of event if requirements are met and store booking in to firebase.
    @IBAction func confirmationButtonTapped(_ sender: Any) {
        let date = Date()
        let dateformatter = DateFormatter()
        let timeformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy"
        let dateResult = dateformatter.string(from: date)
        
        timeformatter.dateFormat = "HH:mm"
        let timeResult = timeformatter.string(from: date)
        
        if dataStorage.sharedInstance.recipedate.compare(dateResult) == .orderedSame && dataStorage.sharedInstance.repicetime.compare(timeResult) == .orderedAscending {
            let alert = UIAlertController(title: "Whoops!", message: "The event time is already in the past, search for another event", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else if dataStorage.sharedInstance.recipedate.compare(dateResult) == .orderedSame && dataStorage.sharedInstance.repicetime.compare(timeResult) == .orderedSame {
            let alert = UIAlertController(title: "Whoops!", message: "You can't book an event that starts now! Search for another event", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            checkFirebase()
        }
    }
    
    func checkFirebase() {
        databaseReference.child("booking").queryOrdered(byChild: "Control").queryEqual(toValue: self.dataStorage.sharedInstance.recipename + "_" + self.dataStorage.sharedInstance.repicetime + "_" + self.dataStorage.sharedInstance.recipedate + "_" + self.dataStorage.sharedInstance.id + "_" + self.userId!).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                let alert = UIAlertController(title: "Whoops!", message: "You already booked this event!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK",
                                             style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.databaseReference.child("acceptedRequests").queryOrdered(byChild: "Control").queryEqual(toValue: self.dataStorage.sharedInstance.recipename + "_" + self.dataStorage.sharedInstance.repicetime + "_" + self.dataStorage.sharedInstance.recipedate + "_" + self.dataStorage.sharedInstance.id + "_" + self.userId!).observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.exists(){
                        let alert = UIAlertController(title: "Whoops!", message: "You are already accepted to this event!", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK",
                                                     style: .default)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.databaseReference.child("declinedRequests").queryOrdered(byChild: "Control").queryEqual(toValue: self.dataStorage.sharedInstance.recipename + "_" + self.dataStorage.sharedInstance.repicetime + "_" + self.dataStorage.sharedInstance.recipedate + "_" + self.dataStorage.sharedInstance.id + "_" + self.userId!).observeSingleEvent(of: .value, with: { (snapshot) in
                            if snapshot.exists(){
                                let alert = UIAlertController(title: "Whoops!", message: "You already did a booking request, but the host of the event declined your request.", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK",
                                                             style: .default)
                                alert.addAction(okAction)
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                self.databaseReference.child("booking").child(self.dataStorage.sharedInstance.recipename + " and " + self.dataStorage.sharedInstance.id + " and " + self.dataStorage.sharedInstance.repicetime + " and " + self.dataStorage.sharedInstance.recipedate + " and " + (Auth.auth().currentUser?.uid)!).setValue([
                                    "Recipename": self.dataStorage.sharedInstance.recipename,
                                    "Recipecuisine": self.dataStorage.sharedInstance.recipecuisine,
                                    "Eventprice": self.dataStorage.sharedInstance.recipeprice,
                                    "Eventdate": self.dataStorage.sharedInstance.recipedate,
                                    "Eventtime": self.dataStorage.sharedInstance.repicetime,
                                    "Eventlatitude": self.dataStorage.sharedInstance.latitude,
                                    "Eventlongitude": self.dataStorage.sharedInstance.longitude,
                                    "Image": self.dataStorage.sharedInstance.image,
                                    "Deletecheck": self.dataStorage.sharedInstance.recipename + "_" + self.dataStorage.sharedInstance.repicetime + "_" + self.dataStorage.sharedInstance.recipedate + "_" + self.userId!,
                                    "Control": self.dataStorage.sharedInstance.recipename + "_" + self.dataStorage.sharedInstance.repicetime + "_" + self.dataStorage.sharedInstance.recipedate + "_" + self.dataStorage.sharedInstance.id + "_" + self.userId!,
                                    "Eventdatetime": self.dataStorage.sharedInstance.recipedate + "_" + self.dataStorage.sharedInstance.repicetime,
                                    "Hostid": self.dataStorage.sharedInstance.id,
                                    "Userid": Auth.auth().currentUser?.uid as Any])
                                
                                let alert = UIAlertController(title: "Booking complete", message: "Now you only have to wait for acceptance of the host", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK",
                                                             style: .default)
                                alert.addAction(okAction)
                                self.present(alert, animated: true, completion: nil)
                            }
                        })
                    }
                })
            }
        })
    }
}
