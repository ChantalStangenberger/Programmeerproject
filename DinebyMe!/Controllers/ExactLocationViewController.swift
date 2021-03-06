//
//  ExactLocationViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 06-04-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
//  Displays the exact event location with address.
//

import UIKit
import GoogleMaps

class ExactLocationViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var adressLabel: UILabel!
    @IBOutlet weak var mapsView: UIView!
    
    var validated : acceptedRequests!
    var mapView: GMSMapView!
    var zoomLevel: Float = 16.0
    let marker = GMSMarker()

    // Set up mapview with some preferences and calls function showMarkerPosition.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Event location"
        adressLabel.contentMode = .scaleAspectFit

        let camera = GMSCameraPosition.camera(withLatitude: validated.latitudeLocation, longitude: validated.longitudeLocation, zoom: zoomLevel)

        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.setAllGesturesEnabled(false)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self

        adressLabel.contentMode = .scaleAspectFit
        mapsView.addSubview(mapView)

        showMarkerPosition()
    }

    // Shows the marker on the map.
    func showMarker(position: CLLocationCoordinate2D) {
        marker.position = position
        marker.title = "Location of the event"
        marker.map = mapView
    }

    // Gets the position for the marker and coordinates for the address.
    func showMarkerPosition() {
        let camera = GMSCameraPosition.camera(withLatitude: validated.latitudeLocation,
                                              longitude: validated.longitudeLocation,
                                              zoom: zoomLevel)
        showMarker(position: camera.target)
        self.reverseGeocodeCoordinate(coordinate: camera.target)
    }
    
    // Changes the latitude and longitude to address.
    private func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
            self.adressLabel.text = lines.joined(separator: "\n")
            
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
