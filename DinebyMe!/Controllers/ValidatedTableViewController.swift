//
//  ValidatedTableViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 06-04-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import UIKit
import Firebase
import XLPagerTabStrip

class ValidatedTableViewController: UITableViewController {
    
    var accepted = [acceptedRequests]()
    let databaseReference = Database.database().reference()
    let userId = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = UIColor(red: 245/255, green: 244/255, blue: 249/255, alpha: 1)
        tableView.separatorStyle = .none
        
        getMyValidatedEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateValidated()
    }
    
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accepted.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "validatedCell", for: indexPath) as! ValidatedTableViewCell
        
        cell.selectionStyle = .none
        cell.recipenameLabel.text = accepted[indexPath.row].recipeName
        cell.cuisineLabel.text = "• " + accepted[indexPath.row].recipeCuisine + " cuisine"
        cell.dateLabel.text = accepted[indexPath.row].eventDate
        cell.timeLabel.text = accepted[indexPath.row].eventTime
        cell.priceLabel.text = accepted[indexPath.row].recipePrice
        cell.validatedImage.downloadedFrom(link: accepted[indexPath.row].addImage)
        cell.validatedImage.contentMode = UIViewContentMode.scaleAspectFill
    databaseReference.child("users").child(accepted[indexPath.row].hostid).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? String
            cell.hostnameLabel.text = "• Host: " + value!
        })
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exactlocationSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPath(for: cell)
            let validated = self.accepted[(indexPath?.row)!]
            let exactlocationViewController = segue.destination as! ExactLocationViewController
            exactlocationViewController.validated = validated
        }
    }
    
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
                                self.databaseReference.child("booking").child(key).removeValue()
                            }
                        }
                    })
                }
            }
        })
        getMyValidatedEvents()
    }
}

extension ValidatedTableViewController : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Validated")
    }
}
