//
//  OverviewTableViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 16-03-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
//  Displays all the events organized by the current user.
//

import UIKit
import Firebase
import GoogleMaps
import XLPagerTabStrip

class OverviewTableViewController: UITableViewController {
    
    let databaseReference = Database.database().reference()
    var newEvent = [NewEvent]()
    let userId = Auth.auth().currentUser?.uid
    
    // Set up view with some preferences and calls function getMyEvents.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor(red: 245/255, green: 244/255, blue: 249/255, alpha: 1)
        
        tableView.separatorStyle = .none
        
        tableView.rowHeight = 324
        
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, self.tabBarController!.tabBar.frame.height, 0)
        self.tableView.contentInset = adjustForTabbarInsets
        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets
        
        getMyEvents()
    }
    
    // Set up some preferences and calls function updateOverview.
    override func viewDidAppear(_ animated: Bool) {
        
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        self.tableView.contentInset = adjustForTabbarInsets
        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets
        
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height)
        
        updateOverview()
    }
    
    // Get the events from firebase organized by the current user.
    func getMyEvents() {
        databaseReference.child("newEvent").queryOrdered(byChild: "id").queryEqual(toValue: userId!).observe(DataEventType.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            self.newEvent.removeAll()
            for data in snapshot {
                guard let eventDict = data.value as? Dictionary<String, AnyObject> else { return }
                let event = NewEvent(eventKey: data.key, eventData: eventDict)
                self.newEvent.append(event)
            }
            self.tableView.reloadData()
        })
    }
    
    // Returns amount of events.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newEvent.count
    }

    // Returns tableview cell with data from firebase.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "overviewCell", for: indexPath) as! OverviewTableViewCell

        cell.selectionStyle = .none
        cell.dateLabel?.text = newEvent[indexPath.row].eventDate
        cell.timeLabel?.text = "Time: " + newEvent[indexPath.row].eventTime
        cell.priceLabel?.text = "€" + newEvent[indexPath.row].recipePrice
        cell.nameLabel?.text = newEvent[indexPath.row].recipeName
        let url = URL(string: newEvent[indexPath.row].addImage)
        cell.eventImage.kf.setImage(with: url)
        cell.eventImage.contentMode = UIViewContentMode.scaleAspectFill

        let savedLocation = CLLocationCoordinate2D(latitude: newEvent[indexPath.row].latitudeLocation, longitude: newEvent[indexPath.row].longitudeLocation)
        self.reverseGeocodeCoordinate(coordinate: savedLocation, sender: cell.adressLabel)
        cell.adressLabel?.tag = indexPath.row
        
        return cell
    }
    
    // Segue to YourGuestTableViewController with details of the events.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "guestlistSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPath(for: cell)
            let newEvent = self.newEvent[(indexPath?.row)!]
            let yourGuestsTableViewController = segue.destination as! YourGuestsTableViewController
            yourGuestsTableViewController.newEvent = newEvent
        }
    }
    
    // Updates events with current date/time. If date/time combination is in the past, delete event data and image from firebase/firebase storage and calls getMyEvents.
    func updateOverview() {
        let date = Date()
        let dateformatter = DateFormatter()
        let timeformatter = DateFormatter()
        
        databaseReference.child("newEvent").observeSingleEvent(of: .value, with: { (snapshot) in
            
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
                    
                    self.databaseReference.child("newEvent").queryOrdered(byChild: "Eventdatetime").queryEqual(toValue: "\(eventdate)_\(eventtime)").observe(.value, with: { (snapshot) in
                        guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
                        for data in snapshot {
                            guard let eventDict = data.value as? Dictionary<String, AnyObject> else { return }
                            let event = NewEvent(eventKey: data.key, eventData: eventDict)
                            Storage.storage().reference(forURL: event.addImage).delete { error in
                                if let error = error {
                                    print(error)
                                }
                            }
                        }
                    })
                    
                    self.databaseReference.child("newEvent").queryOrdered(byChild: "Eventdatetime").queryEqual(toValue: "\(eventdate)_\(eventtime)").observe(.value, with: { (snapshot) in
                        if let eventDate = snapshot.value as? [String: [String: AnyObject]] {
                            for (key, _) in eventDate  {
                                self.databaseReference.child("newEvent").child(key).removeValue()
                            }
                        }
                    })
                }
            }
        })
        tableView.reloadData()
        getMyEvents()
    }
    
    // Convert the latitude and longitude to address.
    private func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D, sender: UILabel) {
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            if self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) != nil {
                let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! OverviewTableViewCell
                cell.adressLabel.text = lines.joined(separator: "\n")
                cell.adressLabel.contentMode = .scaleAspectFit
                
                self.view.layoutIfNeeded()
            } else {
                print("error")
            }
        }
    }
}

// With the function of IndicatorInfoProvider the title of this tableviewcontroller can be set in the buttonbar.
extension OverviewTableViewController : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Overview")
    }
}
