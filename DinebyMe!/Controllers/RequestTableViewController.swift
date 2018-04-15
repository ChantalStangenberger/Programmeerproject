//
//  RequestTableViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 16-03-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
//  Displays all the requests done by other users for your events.
//  Requests can be accepted or declined.
//

import UIKit
import Firebase
import XLPagerTabStrip

class RequestTableViewController: UITableViewController {
    
    let databaseReference = Database.database().reference()
    var booking = [Bookings]()
    let userId = Auth.auth().currentUser?.uid

    // Set up view with some preferences and call function getMyBookingRequests.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor(red: 245/255, green: 244/255, blue: 249/255, alpha: 1)
        
        tableView.separatorStyle = .none
        
        tableView.rowHeight = 230
        
        getMyBookingRequests()
    }
    
    // Set up some preferences and calls function updateRequests.
    override func viewDidAppear(_ animated: Bool) {
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height)
        updateRequests()
    }
    
    // Get all booking requests from firebase.
    func getMyBookingRequests() {
        databaseReference.child("booking").queryOrdered(byChild: "Hostid").queryEqual(toValue: userId!).observe(DataEventType.value, with: { (snapshot) in
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
    
    // Returns the amount of booking requests.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booking.count
    }
    
    // Returns tableview cell with data from firebase and set actions to the buttons in the cell.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as! RequestTableViewCell
        
        cell.selectionStyle = .none
        cell.acceptButton.layer.cornerRadius = 4
        cell.declineButton.layer.cornerRadius = 4
        cell.eventdateLabel?.text = booking[indexPath.row].eventDate
        cell.eventtimeLabel?.text = booking[indexPath.row].eventTime
        cell.questionLabel?.text = "Would like to eat \(booking[indexPath.row].recipeName) on \(booking[indexPath.row].eventDate) by you!"
    databaseReference.child("users").child(booking[indexPath.row].userid).child("name").observe(DataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? String
            cell.nameofbookerLabel?.text = value!
        })
        
        cell.acceptButton.addTarget(self, action: #selector(RequestTableViewController.acceptRequest), for: .touchUpInside)
        cell.declineButton.addTarget(self, action: #selector(RequestTableViewController.declineRequest), for: .touchUpInside)
        cell.acceptButton.tag = indexPath.row
        cell.declineButton.tag = indexPath.row
        return cell
    }
    
    // When the accept button is pressed: add info to firebase (acceptedRequests) and delete booking request from firebase.
    @objc func acceptRequest(sender: UIButton) {
        let alert = UIAlertController(title: "Request accepted", message: "Your guest will be informed that you has accepted the request", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    
        let acceptTag = sender.tag
        
        let values = ["Recipename": booking[acceptTag].recipeName as String, "Eventtime": booking[acceptTag].eventTime as String, "Eventdate": booking[acceptTag].eventDate as String, "Userid": booking[acceptTag].userid, "Cuisine": booking[acceptTag].recipeCuisine, "Price": booking[acceptTag].recipePrice, "latitude": booking[acceptTag].latitudeLocation, "longitude": booking[acceptTag].longitudeLocation, "Control": booking[acceptTag].recipeName + "_" + booking[acceptTag].eventTime + "_" + booking[acceptTag].eventDate + "_" + booking[acceptTag].hostid + "_" + booking[acceptTag].userid, "Image": booking[acceptTag].addImage, "Eventdatetime": booking[acceptTag].eventDate + "_" + booking[acceptTag].eventTime, "Hostid": booking[acceptTag].hostid as String] as [String : Any]
        self.databaseReference.child("acceptedRequests").child(booking[acceptTag].recipeName + " and " + booking[acceptTag].hostid + " and " + booking[acceptTag].eventTime + " and " + booking[acceptTag].eventDate + " and " + booking[acceptTag].userid).setValue(values)
        
        self.databaseReference.child("booking").child(booking[acceptTag].recipeName + " and " + booking[acceptTag].hostid + " and " + booking[acceptTag].eventTime + " and " + booking[acceptTag].eventDate + " and " + booking[acceptTag].userid).removeValue()
        
        self.booking.remove(at: acceptTag)
        self.tableView.reloadData()
    }
    
    // When the decline button is pressed: add info to firebase (declinedRequests) and delete booking request from firebase.
    @objc func declineRequest(sender: UIButton) {
        let alert = UIAlertController(title: "Request declined", message: "You have declined the request", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
        let declineTag = sender.tag
        
        let values = ["Recipename": booking[declineTag].recipeName as String, "Eventtime": booking[declineTag].eventTime as String, "Eventdate": booking[declineTag].eventDate as String, "Userid": booking[declineTag].userid, "Cuisine": booking[declineTag].recipeCuisine, "Price": booking[declineTag].recipePrice, "latitude": booking[declineTag].latitudeLocation, "longitude": booking[declineTag].longitudeLocation, "Control": booking[declineTag].recipeName + "_" + booking[declineTag].eventTime + "_" + booking[declineTag].eventDate + "_" + booking[declineTag].hostid + "_" + booking[declineTag].userid, "Image": booking[declineTag].addImage, "Hostid": booking[declineTag].hostid as String] as [String : Any]
        self.databaseReference.child("declinedRequests").child(booking[declineTag].recipeName + " and " + booking[declineTag].hostid + " and " + booking[declineTag].eventTime + " and " + booking[declineTag].eventDate + " and " + booking[declineTag].userid).setValue(values)
        
        self.databaseReference.child("booking").child(booking[declineTag].recipeName + " and " + booking[declineTag].hostid + " and " + booking[declineTag].eventTime + " and " + booking[declineTag].eventDate + " and " + booking[declineTag].userid).removeValue()
        self.booking.remove(at: declineTag)
        self.tableView.reloadData()
    }
    
    // Updates events with current date/time. If date/time combination is in the past, delete event data from firebase and calls getMyBookingRequests.
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
        getMyBookingRequests()
    }
}

// With the function of IndicatorInfoProvider the title of this tableviewcontroller can be set in the buttonbar.
extension RequestTableViewController : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Requests")
    }
}
