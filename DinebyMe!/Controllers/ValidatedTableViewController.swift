//
//  ValidatedTableViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 06-04-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
//  Displays the validated booking request of the current user.
//

import UIKit
import Firebase
import XLPagerTabStrip

class ValidatedTableViewController: UITableViewController {
    
    var accepted = [acceptedRequests]()
    let databaseReference = Database.database().reference()
    let userId = Auth.auth().currentUser?.uid

    // Set up view with some preferences and calls function getMyValidatedEvents.
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = UIColor(red: 245/255, green: 244/255, blue: 249/255, alpha: 1)
        tableView.separatorStyle = .none
        
        getMyValidatedEvents()
    }
    
    // Set up some preferences and calls function updateValidated.
    override func viewDidAppear(_ animated: Bool) {
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height)
        updateValidated()
    }
    
    // Get the validated events from firebase.
    func getMyValidatedEvents() {
        databaseReference.child("acceptedRequests").queryOrdered(byChild: "Userid").queryEqual(toValue: userId!).observe(DataEventType.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            self.accepted.removeAll()
            for data in snapshot {
                guard let eventDict = data.value as? Dictionary<String, AnyObject> else { return }
                let validated = acceptedRequests(eventKey: data.key, eventData: eventDict)
                self.accepted.append(validated)
            }
            self.tableView.reloadData()
        })
    }

    // Returns amount of validated events.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accepted.count
    }
    
    // Returns tableview cell with data from firebase.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "validatedCell", for: indexPath) as! ValidatedTableViewCell
        
        cell.selectionStyle = .none
        cell.recipenameLabel.text = accepted[indexPath.row].recipeName
        cell.cuisineLabel.text = "• " + accepted[indexPath.row].recipeCuisine
        cell.dateLabel.text = accepted[indexPath.row].eventDate
        cell.timeLabel.text = accepted[indexPath.row].eventTime
        cell.priceLabel.text = accepted[indexPath.row].recipePrice
        let url = URL(string: accepted[indexPath.row].addImage)
        cell.validatedImage.kf.setImage(with: url)
        cell.validatedImage.contentMode = UIViewContentMode.scaleAspectFill
    databaseReference.child("users").child(accepted[indexPath.row].hostid).child("name").observe(DataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? String
            cell.hostnameLabel.text = "• Host: " + value!
        })
        
        return cell
    }
    
    // Segue to ExactLocationViewController with details of the validated events.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exactlocationSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPath(for: cell)
            let validated = self.accepted[(indexPath?.row)!]
            let exactlocationViewController = segue.destination as! ExactLocationViewController
            exactlocationViewController.validated = validated
        }
    }
    
    // Updates events with current date/time. If date/time combination is in the past, delete event data from firebase and calls getMyValidatedEvents.
    func updateValidated() {
        let date = Date()
        let dateformatter = DateFormatter()
        let timeformatter = DateFormatter()
        
        databaseReference.child("acceptedRequests").observeSingleEvent(of: .value, with: { (snapshot) in
            
            for snap in snapshot.children {
                let userSnap = snap as! DataSnapshot
                let userDict = userSnap.value as! [String:AnyObject]
                let eventdate = userDict["Eventdate"] as! String
                let eventtime = userDict["Eventtime"] as! String
                
                dateformatter.dateFormat = "dd-MM-yyyy"
                let dateResult = dateformatter.string(from: date)
                
                timeformatter.dateFormat = "HH:mm"
                let timeResult = timeformatter.string(from: date)
                
                if (eventdate.compare(dateResult) == .orderedAscending) || (eventdate.compare(dateResult) == .orderedSame) && (eventtime.compare(timeResult) == .orderedAscending) {
                    
                    self.databaseReference.child("acceptedRequests").queryOrdered(byChild: "Eventdatetime").queryEqual(toValue: "\(eventdate)_\(eventtime)").observe(.value, with: { (snapshot) in
                        if let eventDate = snapshot.value as? [String: [String: AnyObject]] {
                            for (key, _) in eventDate  {
                                self.databaseReference.child("acceptedRequests").child(key).removeValue()
                            }
                        }
                    })
                }
            }
        })
        tableView.reloadData()
        getMyValidatedEvents()
    }
}

// With the function of IndicatorInfoProvider the title of this tableviewcontroller can be set in the buttonbar.
extension ValidatedTableViewController : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Validated")
    }
}
