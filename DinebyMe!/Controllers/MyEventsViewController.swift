//
//  MyEventsViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 16-03-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
//  https://www.youtube.com/watch?v=tkR2USQlkHI
//

import UIKit
import XLPagerTabStrip

class MyEventsViewController: ButtonBarPagerTabStripViewController {
    
    override func viewDidLoad() {
        self.loadDesign()
        
        super.viewDidLoad()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_overview = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "overviewTable")
        let child_request = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "requestTable")
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
}

