//
//  RequestedTableViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 06-04-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import UIKit
import Firebase
import XLPagerTabStrip

class RequestedTableViewController: UITableViewController {
    
    let databaseReference = Database.database().reference()
    var booking = [Bookings]()
    let userId = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = UIColor(red: 245/255, green: 244/255, blue: 249/255, alpha: 1)
        tableView.separatorStyle = .none
        
        tableView.rowHeight = 325
        
        getMyRequests()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateRequests()
    }
    
    func getMyRequests() {
        databaseReference.child("booking").queryOrdered(byChild: "Userid").queryEqual(toValue: userId!).observe(DataEventType.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            self.booking.removeAll()
            for data in snapshot {
                guard let eventDict = data.value as? Dictionary<String, AnyObject> else { return }
                let event = Bookings(eventKey: data.key, eventData: eventDict)
                self.booking.append(event)
            }
            self.tableView.reloadData()
        })
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booking.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestedCell", for: indexPath) as! RequestedTableViewCell
        
        cell.selectionStyle = .none
        cell.recipenameLabel.text = booking[indexPath.row].recipeName
        cell.dateLabel.text = booking[indexPath.row].eventDate
        cell.timeLabel.text = booking[indexPath.row].eventTime
        cell.cuisineLabel.text = "• " + booking[indexPath.row].recipeCuisine + " cuisine"
        cell.priceLabel.text = booking[indexPath.row].recipePrice
    databaseReference.child("users").child(booking[indexPath.row].hostid).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? String
            cell.hostnameLabel.text = "• Host: " + value!
        })
        cell.imageRequested.downloadedFrom(link: booking[indexPath.row].addImage)
        cell.imageRequested.contentMode = UIViewContentMode.scaleAspectFill
        
        return cell
    }
    
    func updateRequests() {
        let date = Date()
        let dateformatter = DateFormatter()
        let timeformatter = DateFormatter()
        
        databaseReference.child("booking").observeSingleEvent(of: .value, with: { (snapshot) in
            
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
                    
                    self.databaseReference.child("booking").queryOrdered(byChild: "Eventdatetime").queryEqual(toValue: "\(eventdate)_\(eventtime)").observe(.value, with: { (snapshot) in
                        if let eventDate = snapshot.value as? [String: [String: AnyObject]] {
                            for (key, _) in eventDate  {
                                self.databaseReference.child("booking").child(key).removeValue()
                            }
                        }
                    })
                }
            }
        })
        getMyRequests()
    }
}

extension RequestedTableViewController : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Requested")
    }
}
