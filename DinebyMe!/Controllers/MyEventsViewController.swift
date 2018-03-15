//
//  MyEventsViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 15-03-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import UIKit

class MyEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

//    @IBOutlet weak var requestsButton: UIButton!
//    @IBOutlet weak var validatedButton: UIButton!
//    @IBOutlet weak var overviewButton: UIButton!
//    @IBOutlet weak var overviewTableView: UITableView!
//    @IBOutlet weak var requestTableView: UITableView!
//    @IBOutlet weak var validatedTableView: UITableView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        requestsButton.addBottomBorderWithColor(color: UIColor(red: 148/255, green: 23/255, blue: 81/255, alpha: 1), width: 2)
//    }
//
//    func updateRequest() {
//        requestTableView.dataSource = self
//        requestTableView.delegate = self
//    }
//
//    func updateOverview() {
//        overviewTableView.dataSource = self
//        overviewTableView.delegate = self
//    }
//
//    func updateValidated() {
//        validatedTableView.dataSource = self
//        validatedTableView.delegate = self
//    }
//
//    @IBAction func requestButtonTapped(_ sender: Any) {
//        requestsButton.addBottomBorderWithColor(color: UIColor(red: 148/255, green: 23/255, blue: 81/255, alpha: 1), width: 2)
//        validatedButton.addBottomBorderWithColor(color: UIColor.white, width: 2)
//        overviewButton.addBottomBorderWithColor(color: UIColor.white, width: 2)
//
//        overviewTableView.isHidden = true
//        requestTableView.isHidden = false
//        validatedTableView.isHidden = true
//
//        updateRequest()
//    }
//
//    @IBAction func validatedButtonTapped(_ sender: Any) {
//        validatedButton.addBottomBorderWithColor(color: UIColor(red: 148/255, green: 23/255, blue: 81/255, alpha: 1), width: 2)
//        requestsButton.addBottomBorderWithColor(color: UIColor.white, width: 2)
//        overviewButton.addBottomBorderWithColor(color: UIColor.white, width: 2)
//
//        overviewTableView.isHidden = true
//        requestTableView.isHidden = true
//        validatedTableView.isHidden = false
//
//        updateValidated()
//    }
//
//    @IBAction func overviewButtonTapped(_ sender: Any) {
//        overviewButton.addBottomBorderWithColor(color: UIColor(red: 148/255, green: 23/255, blue: 81/255, alpha: 1), width: 2)
//        requestsButton.addBottomBorderWithColor(color: UIColor.white, width: 2)
//        validatedButton.addBottomBorderWithColor(color: UIColor.white, width: 2)
//
//        overviewTableView.isHidden = false
//        requestTableView.isHidden = true
//        validatedTableView.isHidden = true
//
//        updateOverview()
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if overviewTableView.isHidden == false {
//            let cell = overviewTableView.dequeueReusableCell(withIdentifier: "personaloverviewCell", for: indexPath) as? PersonalOverviewTableViewCell
//
//            return cell!
//
//        } else if requestTableView.isHidden == false {
//            let cell = requestTableView.dequeueReusableCell(withIdentifier: "personalrequestCell", for: indexPath) as? PersonalRequestTableViewCell
//
//            return cell!
//
//        } else if validatedTableView.isHidden == false {
//            let cell = validatedTableView.dequeueReusableCell(withIdentifier: "personalvalidatedCell", for: indexPath) as? PersonalValidatedTableViewCell
//
//            return cell!
//
//        }
//        return cell
//    }
}
