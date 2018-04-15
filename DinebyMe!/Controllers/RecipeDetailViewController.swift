//
//  RecipeDetailViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 15-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
//  Shows details of a specific event chosen by a user.
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

    // Set up view with some preferences and calls function updateUI and addCircleLocation.
    override func viewDidLoad() {
        super.viewDidLoad()
        locationLabel.addBottomBorderWithColor(color: UIColor.darkGray, width: 2)
        recipenameLabel.addBottomBorderWithColor(color: UIColor.darkGray, width: 2)
        requesttobookButton.layer.cornerRadius = 4
        
        updateUI()
        
        dataStorage.sharedInstance.recipename = recipenameLabel.text!
        dataStorage.sharedInstance.recipeprice = recipepriceLabel.text!
        dataStorage.sharedInstance.recipedate = recipedateLabel.text!
        dataStorage.sharedInstance.id = newEvent.userid
        dataStorage.sharedInstance.recipecuisine = recipecuisineLabel.text!
        dataStorage.sharedInstance.repicetime = recipetimeLabel.text!
        dataStorage.sharedInstance.latitude = newEvent.latitudeLocation
        dataStorage.sharedInstance.longitude = newEvent.longitudeLocation
        dataStorage.sharedInstance.image = newEvent.addImage
        
        let camera = GMSCameraPosition.camera(withLatitude: newEvent.latitudeLocation, longitude: newEvent.longitudeLocation, zoom: zoomLevel)
        
        mapsView = GMSMapView.map(withFrame: mapView.bounds, camera: camera)
        mapsView.settings.setAllGesturesEnabled(false)
        mapsView.delegate = self
        
        mapView.addSubview(mapsView)
        
        addCircleLocation()
    }
    
    // Add a circle on the map.
    func addCircleLocation() {
        let circleCenter = CLLocationCoordinate2D(latitude: newEvent.latitudeLocation, longitude: newEvent.longitudeLocation)
        let circ = GMSCircle(position: circleCenter, radius: 1000)
        circ.fillColor = UIColor(red: 0.58, green: 0.09, blue: 0.32, alpha: 0.3)
        circ.strokeColor = UIColor(red: 0.58, green: 0.09, blue: 0.32, alpha: 0.9)
        circ.strokeWidth = 5
        circ.map = mapsView
    }
    
    // Updates scene.
    func updateUI() {
        recipenameLabel.text = newEvent.recipeName
        recipecuisineLabel.text = newEvent.recipeCuisine + " cuisine"
        recipepriceLabel.text = "€ " + newEvent.recipePrice
        recipetimeLabel.text = newEvent.eventTime
        recipedateLabel.text = newEvent.eventDate
        let url = URL(string: newEvent.addImage)
        recipeImage.kf.setImage(with: url)
        recipeImage.contentMode = UIViewContentMode.scaleAspectFill
    }
}
