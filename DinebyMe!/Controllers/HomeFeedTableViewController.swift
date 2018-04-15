//
//  HomeFeedTableViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 15-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
//  Overview of all current events of other DinebyMe! users.
//  Used https://github.com/onevcat/Kingfisher to download the photos from firebase.
//

import UIKit
import Firebase
import Kingfisher
import FirebaseStorage

class HomeFeedTableViewController: UITableViewController {
    
    let databaseReference = Database.database().reference()
    var newEvent = [NewEvent]()
    let userId = Auth.auth().currentUser?.uid
    
    // Set up view with some preferences and call function getNewEvents.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "backgroundpastel.png")
        let imageView = UIImageView(image: backgroundImage)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
        self.tableView.backgroundView = imageView
        self.tableView.separatorStyle = .none
        
        getNewEvent()
        
        self.edgesForExtendedLayout = UIRectEdge()
        self.extendedLayoutIncludesOpaqueBars = false
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    // Set longitude and latitude values to 0 and calls function updateEvents.
    override func viewWillAppear(_ animated: Bool) {
        globalStruct.latitude = 0.0
        globalStruct.longitude = 0.0
        
        tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height)
        updateEvents()
    }
    
    // Get all new events from firebase except data from current user.
    func getNewEvent() {
        databaseReference.child("newEvent").observe(DataEventType.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            self.newEvent.removeAll()
            for data in snapshot {
                guard let eventDict = data.value as? Dictionary<String, AnyObject> else { return }
                let event = NewEvent(eventKey: data.key, eventData: eventDict)
                if event.userid != self.userId {
                    self.newEvent.append(event)
                }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchdetailCell", for: indexPath) as! SearchDetailTableViewCell
        cell.selectionStyle = .none
        cell.dateLabel?.text = newEvent[indexPath.row].eventDate
        cell.recipenameLabel?.text = newEvent[indexPath.row].recipeName
        cell.recipepriceLabel?.text = "€" + newEvent[indexPath.row].recipePrice
        let url = URL(string: newEvent[indexPath.row].addImage)
        cell.addImage.kf.setImage(with: url)
        cell.addImage.contentMode = UIViewContentMode.scaleAspectFill
    databaseReference.child("users").child(newEvent[indexPath.row].userid).child("name").observe(DataEventType.value, with: { (snapshot) in
        let value = snapshot.value as? String
        cell.hostnameLabel?.text = "Organized by " + value!
        })
            
        return cell
    }
    
    // Segue to RecipeDetailViewController with details of the events.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipedetailSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPath(for: cell)
            let newEvent = self.newEvent[(indexPath?.row)!]
            let recipeDetailViewController = segue.destination as! RecipeDetailViewController
            recipeDetailViewController.newEvent = newEvent
        }
    }
    
    // Updates events with current date/time. If date/time combination is in the past, delete event data and image from firebase/firebase storage and calls getNewEvents.
    func updateEvents() {
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
        getNewEvent()
    }
    
    // When tapped at the info button an alert with app info appears.
    @IBAction func infoButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Overview events", message: "Here you can find all the active events. When you want to add an event you can press on the '+'. Your own events are not listed in this feed, but you can find them under 'My Events'.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

