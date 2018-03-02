//
//  AddLocationViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 26-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase

class AddLocationViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var zoomLevel: Float = 14.0
    
    let marker = GMSMarker()
    
    let databaseReference = Database.database().reference()
    
    // A default location to use when location permission is not granted.
    let defaultLocation = CLLocation(latitude: 52.370216, longitude: 4.895168)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
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
        
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
        
        showCurrentMarkerPosition()
    }
    
    func showMarker(position: CLLocationCoordinate2D) {
        marker.position = position
        marker.title = "Currently selected event place "
        marker.snippet = "Move marker to change event place or save event place"
        marker.map = mapView
        marker.isDraggable = true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude,
                                              longitude: coordinate.longitude,
                                              zoom: zoomLevel)
        showMarker(position: camera.target)
        
        globalStruct.latcoordinate = coordinate.latitude
        globalStruct.longcoordinate = coordinate.longitude
    }
    
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
    
    func showCurrentMarkerPosition() {
        if globalStruct.latitude != 0.0 || globalStruct.longitude != 0.0 {
            let camera = GMSCameraPosition.camera(withLatitude: globalStruct.latitude,
                                                  longitude: globalStruct.longitude,
                                                  zoom: zoomLevel)
            showMarker(position: camera.target)
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
            print("Location access was restricted.")
            mapView.isHidden = false
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
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

