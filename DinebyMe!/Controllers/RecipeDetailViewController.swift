//
//  RecipeDetailViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 15-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import UIKit
import GoogleMaps

class RecipeDetailViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipenameLabel: UILabel!
    @IBOutlet weak var recipecuisineLabel: UILabel!
    @IBOutlet weak var recipepriceLabel: UILabel!
    @IBOutlet weak var recipetimeLabel: UILabel!
    @IBOutlet weak var recipedateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var requesttobookButton: UIButton!
    @IBOutlet weak var mapView: UIView!
    
    var newEvent: NewEvent!
    let dataStorage = DataStorage()
    var mapsView: GMSMapView!
    var zoomLevel: Float = 12.8
    let marker = GMSMarker()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationLabel.addBottomBorderWithColor(color: UIColor.darkGray, width: 2)
        recipenameLabel.addBottomBorderWithColor(color: UIColor.darkGray, width: 2)
        requesttobookButton.layer.cornerRadius = 4
        
        updateUI()
        
        dataStorage.sharedInstance.recipename = recipenameLabel.text!
        dataStorage.sharedInstance.recipeprice = recipepriceLabel.text!
        dataStorage.sharedInstance.recipedate = recipedateLabel.text!
        dataStorage.sharedInstance.id = newEvent.id
        
        let camera = GMSCameraPosition.camera(withLatitude: newEvent.latitudeLocation, longitude: newEvent.longitudeLocation, zoom: zoomLevel)
        
        mapsView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapsView.settings.scrollGestures = false
        mapsView.settings.zoomGestures = false
        mapsView.settings.rotateGestures = false
        mapsView.delegate = self
        
        mapView.addSubview(mapsView)
        
        addCircleLocation()
    }
    
    func addCircleLocation() {
        let circleCenter = CLLocationCoordinate2D(latitude: newEvent.latitudeLocation, longitude: newEvent.longitudeLocation)
        let circ = GMSCircle(position: circleCenter, radius: 1000)
        circ.fillColor = UIColor(red: 0.58, green: 0.09, blue: 0.32, alpha: 0.3)
        circ.strokeColor = UIColor(red: 0.58, green: 0.09, blue: 0.32, alpha: 0.9)
        circ.strokeWidth = 5
        circ.map = mapsView
    }
    
    // updates scene
    func updateUI() {
        recipenameLabel.text = newEvent.recipeName
        recipecuisineLabel.text = newEvent.recipeCuisine
        recipepriceLabel.text = "€ " + newEvent.recipePrice
        recipetimeLabel.text = newEvent.eventTime
        recipedateLabel.text = newEvent.eventDate
        recipeImage.downloadedFrom(link: newEvent.addImage)
    }
}
