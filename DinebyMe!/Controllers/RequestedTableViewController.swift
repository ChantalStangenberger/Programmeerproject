//
//  RequestedTableViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 06-04-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
//  Displays the requested bookings of the current user.
//

import UIKit
import Firebase
import XLPagerTabStrip

class RequestedTableViewController: UITableViewController {
    
    let databaseReference = Database.database().reference()
    var booking = [Bookings]()
    let userId = Auth.auth().currentUser?.uid

    // Set up view with some preferences and call function getMyRequests.
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = UIColor(red: 245/255, green: 244/255, blue: 249/255, alpha: 1)
        tableView.separatorStyle = .none
        
        tableView.rowHeight = 324
        
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, self.tabBarController!.tabBar.frame.height, 0)
        self.tableView.contentInset = adjustForTabbarInsets
        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets
        
        getMyRequests()
    }
    
    // Set up some preferences and calls function updateOverview.
    override func viewDidAppear(_ animated: Bool) {
        
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        self.tableView.contentInset = adjustForTabbarInsets
        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets
        
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height)
        updateRequests()
    }
    
    // Get the events from firebase booked by the current user.
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

    // Returns amount of booking requests.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booking.count
    }
    
    // Returns tableview cell with data from firebase.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestedCell", for: indexPath) as! RequestedTableViewCell
        
        cell.selectionStyle = .none
        cell.recipenameLabel.text = booking[indexPath.row].recipeName
        cell.dateLabel.text = booking[indexPath.row].eventDate
        cell.timeLabel.text = booking[indexPath.row].eventTime
        cell.cuisineLabel.text = "• " + booking[indexPath.row].recipeCuisine
        cell.priceLabel.text = booking[indexPath.row].recipePrice
    databaseReference.child("users").child(booking[indexPath.row].hostid).child("name").observe(DataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? String
            cell.hostnameLabel.text = "• Host: " + value!
        })
        let url = URL(string: booking[indexPath.row].addImage)
        cell.imageRequested.kf.setImage(with: url)
        cell.imageRequested.contentMode = UIViewContentMode.scaleAspectFill
        
        return cell
    }
    
    // Updates events with current date/time. If date/time combination is in the past, delete event data from firebase and calls getMyRequests.
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
        tableView.reloadData()
        getMyRequests()
    }
}

// With the function of IndicatorInfoProvider the title of this tableviewcontroller can be set in the buttonbar.
extension RequestedTableViewController : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Requested")
    }
}
