//
//  OverviewTableViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 16-03-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import UIKit
import Firebase
import XLPagerTabStrip

class OverviewTableViewController: UITableViewController {
    
    let databaseReference = Database.database().reference()
    var newEvent = [NewEvent]()
    let userId = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = UIImage(named: "backgroundpastel.png")
        let imageView = UIImageView(image: backgroundImage)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
        self.tableView.backgroundView = imageView
        
        tableView.separatorStyle = .none
        
        getMyEvents()
    }
    
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
            
            if self.newEvent.count == 0 {
                let backgroundImage = UIImage(named: "backgroundpastel.png")
                let imageView = UIImageView(image: backgroundImage)
                let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
                let blurView = UIVisualEffectView(effect: blurEffect)
                blurView.frame = imageView.bounds
                imageView.addSubview(blurView)
                self.tableView.backgroundView = imageView
                
                let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
                emptyLabel.text = "There is nothing to show yet"
                emptyLabel.font = UIFont(name: "thonburi", size: 17)!
                emptyLabel.textAlignment = NSTextAlignment.center
                self.tableView.addSubview(emptyLabel)
                self.tableView.separatorStyle = .none
            }
        })
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newEvent.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "overviewCell", for: indexPath) as! OverviewTableViewCell
        
        cell.MyOnlineEvents?.text = newEvent[indexPath.row].eventDate

        return cell
    }
}

extension OverviewTableViewController : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Overview")
    }
}
