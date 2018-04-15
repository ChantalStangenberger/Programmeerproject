//
//  AddLocationViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 26-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
//  Displays a map where the user can add their event location by clicking on the map. Shows also the current position of the user if it is allowed.
//  Used https://www.raywenderlich.com/179565/google-maps-ios-sdk-tutorial-getting-started to display google maps setup.
//

import UIKit
import GoogleMaps
import Firebase

class AddLocationViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var mapsView: UIView!
    @IBOutlet weak var adressLabel: UILabel!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var zoomLevel: Float = 14.0
    
    let marker = GMSMarker()
    
    let databaseReference = Database.database().reference()
    
    // A default location: used when location permission is not granted.
    let defaultLocation = CLLocation(latitude: 52.370216, longitude: 4.895168)
    
    // Set up mapview with some preferences and calls function showCurrentMarkerPosition.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 220000
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        adressLabel.contentMode = .scaleAspectFit
        
        mapsView.addSubview(mapView)
        mapView.isHidden = true
        
        showCurrentMarkerPosition()
    }
    
    // Shows the marker on the map.
    func showMarker(position: CLLocationCoordinate2D) {
        marker.position = position
        marker.title = "Currently selected event place "
        marker.snippet = "Replace marker to change event place or save event place"
        marker.map = mapView
    }
    
    // When tapped at a location, show a marker on that location.
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude,
                                              longitude: coordinate.longitude,
                                              zoom: zoomLevel)
        showMarker(position: camera.target)
        
        self.reverseGeocodeCoordinate(coordinate: coordinate)
        
        globalStruct.latcoordinate = coordinate.latitude
        globalStruct.longcoordinate = coordinate.longitude
    }
    
    // Saves the marked location into a global struct.
    @IBAction func saveButtonTapped(_ sender: AnyObject) {
        if marker.map != nil {
            let alert = UIAlertController(title: "Location saved", message: "You set the location of the event succesfully.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
            globalStruct.latitude = globalStruct.latcoordinate
            globalStruct.longitude = globalStruct.longcoordinate
            
        } else {
            let alert = UIAlertController(title: "Error", message: "You have not placed a marker.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // If the event location is already added and saved, show this event location with a marker.
    func showCurrentMarkerPosition() {
        if globalStruct.latitude != 0.0 || globalStruct.longitude != 0.0 {
            let camera = GMSCameraPosition.camera(withLatitude: globalStruct.latitude,
                                                  longitude: globalStruct.longitude,
                                                  zoom: zoomLevel)
            showMarker(position: camera.target)
            self.reverseGeocodeCoordinate(coordinate: camera.target)
        }
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

extension AddLocationViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            mapView.isHidden = false
        case .denied:
            mapView.isHidden = false
        case .notDetermined:
            mapView.isHidden = false
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
    }
}
