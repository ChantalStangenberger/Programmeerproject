//
//  SearchDetailTableViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 15-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import UIKit
import Firebase

class SearchDetailTableViewController: UITableViewController {
    
    let databaseReference = Database.database().reference()
    var newEvent = [NewEvent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImage(named: "backgroundpastel.png")
        let imageView = UIImageView(image: backgroundImage)
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = imageView.bounds
        imageView.addSubview(blurView)
        self.tableView.backgroundView = imageView
        
        tableView.separatorColor = UIColor.darkGray
        
        getNewEvent()
    }
    
    func getNewEvent () {
        databaseReference.child("newEvent").observe(DataEventType.value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            self.newEvent.removeAll()
            for data in snapshot {
                guard let movieDict = data.value as? Dictionary<String, AnyObject> else { return }
                let movie = NewEvent(eventKey: data.key, eventData: movieDict)
                self.newEvent.append(movie)
            }
            self.tableView.reloadData()
        })
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newEvent.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchdetailCell", for: indexPath) as? SearchDetailTableViewCell
        cell?.dateLabel?.text = newEvent[indexPath.row].eventDate
        cell?.recipenameLabel?.text = newEvent[indexPath.row].recipeName
        cell?.recipepriceLabel?.text = newEvent[indexPath.row].recipePrice
        cell?.addImage.downloadedFrom(link: newEvent[indexPath.row].addImage)
        cell?.addImage.sizeToFit()
        return cell!
    }
    
    // makes the background of the cell transparent
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipedetailSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPath(for: cell)
            let newEvent = self.newEvent[(indexPath?.row)!]
            let recipeDetailViewController = segue.destination as! RecipeDetailViewController
            recipeDetailViewController.newEvent = newEvent
        }
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

