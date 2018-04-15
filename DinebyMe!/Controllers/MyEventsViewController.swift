//
//  MyEventsViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 16-03-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
//  Set up button bar by https://www.youtube.com/watch?v=tkR2USQlkHI . User can swith between two tableviews (overview and request).
//

import UIKit
import Firebase
import FacebookCore
import XLPagerTabStrip

class MyEventsViewController: ButtonBarPagerTabStripViewController {
    
    // Set up view with some preferences.
    override func viewDidLoad() {
        self.loadDesign()
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 245/255, green: 244/255, blue: 249/255, alpha: 1)
    }
    
    // Set latitude and logitude to 0.
    override func viewWillAppear(_ animated: Bool) {
        globalStruct.latitude = 0.0
        globalStruct.longitude = 0.0
    }
    
    // Set two tableviews (overview and request) under the buttonbar.
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_overview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "overviewTable")
        let child_request = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "requestTable")
        return [child_overview, child_request]
    }
    
    // Design preferences for the buttonbar.
    func loadDesign() {
        self.settings.style.selectedBarHeight = 1
        self.settings.style.buttonBarItemBackgroundColor = .white
        self.settings.style.selectedBarBackgroundColor = UIColor(red: 148/255, green: 23/255, blue: 81/255, alpha: 1)
        self.settings.style.buttonBarItemFont = UIFont(name: "thonburi", size: 14)!
        self.settings.style.selectedBarHeight = 4.0
        self.settings.style.buttonBarMinimumLineSpacing = 0
        self.settings.style.buttonBarItemsShouldFillAvailableWidth = true
        self.settings.style.buttonBarLeftContentInset = 0
        self.settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = UIColor.black
            newCell?.label.textColor = UIColor(red: 148/255, green: 23/255, blue: 81/255, alpha: 1)
        }
    }
    
    // User can sign out and go to the BeginView: check for facebook acces and otherwise sign out from firebase.
    @IBAction func signoutButtonTapped(_ sender: Any) {
        if facebookAccesToken != nil {
            AccessToken.current = nil
            facebookAccesToken = nil
        }
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "signoutSegue", sender: self)
            print("Sign Out Successful")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    // When tapped at the info button an alert with app info appears.
    @IBAction func infoButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "My events", message: "Under 'overview' you can find all your active events. When you tap at a specific event you can see which guests are comming. Under 'requests' you can find the booking requests from other users for your events. You can accept or decline the requests. ", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

