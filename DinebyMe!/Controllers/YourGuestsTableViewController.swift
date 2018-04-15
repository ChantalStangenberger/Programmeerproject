//
//  YourGuestsTableViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 06-04-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
//  Displays the guest who are coming to your event.
//

import UIKit
import Firebase

class YourGuestsTableViewController: UITableViewController {
    
    var newEvent: NewEvent!
    var accepted = [acceptedRequests]()
    let databaseReference = Database.database().reference()

    // Set up view with some preferences and call function getGuestList.
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Your guests"
        self.tableView.backgroundColor = UIColor(red: 245/255, green: 244/255, blue: 249/255, alpha: 1)
        
        tableView.separatorStyle = .none
        
        getGuestList()
    }
    
    // Returns amount of guests.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accepted.count
    }
    
    // Returns tableview cell with guests names and email from firebase.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "yourguestsCell", for: indexPath) as! YourGuestsTableViewCell
        
        cell.selectionStyle = .none
    databaseReference.child("users").child(accepted[indexPath.row].userid).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? String
                cell.yourguestsnameLabel?.text = " • " + value!
        })
    databaseReference.child("users").child(accepted[indexPath.row].userid).child("email").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? String
                cell.yourguestsemailLabel?.text = "    " + value!
        })
        
        return cell
    }
    
    // Get all guests from firebase.
    func getGuestList() {
        databaseReference.child("acceptedRequests").queryOrdered(byChild: "Image").queryEqual(toValue: newEvent.addImage).observe(DataEventType.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            self.accepted.removeAll()
            for data in snapshot {
                guard let eventDict = data.value as? Dictionary<String, AnyObject> else { return }
                let guest = acceptedRequests(eventKey: data.key, eventData: eventDict)
                self.accepted.append(guest)
            }
            self.tableView.reloadData()
        })
    }
    
    // Makes the background of the cell transparent.
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
}
