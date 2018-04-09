//
//  BookingsTableViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 15-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class BookingsViewController:  ButtonBarPagerTabStripViewController {
    
    override func viewDidLoad() {
        self.loadDesign()
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 245/255, green: 244/255, blue: 249/255, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        globalStruct.latitude = 0.0
        globalStruct.longitude = 0.0
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_overview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "requestedTable")
        let child_request = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "validatedTable")
        return [child_overview, child_request]
    }
    
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
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Event Bookings", message: "Here you can find the events that you have been booking. Under 'requested' are events listed that not yet have been approved by the host of the event. When an event disappears from the requested section, the host of the event has declined your request. Under 'validated' you can find the approved requests for the events. When you tap on a validated event you can see the address of that event.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
