//
//  NewEvent.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 28-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import Foundation
import Firebase

class NewEvent {
    private var _eventDate: String!
    private var _eventTime: String!
    private var _recipeCuisine: String!
    private var _recipeName: String!
    private var _recipePrice: String!
    private var _addImage: String!
    private var _latitudeLocation: Double!
    private var _longitudeLocation: Double!
    private var _id: String!
    private var _eventKey:  String!
    private var _eventRef: DatabaseReference!
    
    var eventDate: String {
        return _eventDate
    }
    
    var eventTime: String {
        return _eventTime
    }
    
    var recipeCuisine: String {
        return _recipeCuisine
    }
    
    var recipeName: String {
        return _recipeName
    }
    
    var recipePrice: String {
        return _recipePrice
    }
    
    var addImage: String {
        return _addImage
    }
    
    var latitudeLocation: Double {
        return _latitudeLocation
    }
    
    var longitudeLocation: Double {
        return _longitudeLocation
    }
    
    var id: String {
        return _id
    }
    
    var eventKey: String {
        return _eventKey
    }
    
    init(eventDate: String, eventTime: String, recipeCuisine: String, recipeName: String, recipePrice: String, addImage: String, latitudeLocation: Double, longitudeLocation: Double, id: String) {
        _eventDate = eventDate
        _eventTime = eventTime
        _recipeCuisine = recipeCuisine
        _recipeName = recipeName
        _recipePrice = recipePrice
        _addImage = addImage
        _latitudeLocation = latitudeLocation
        _longitudeLocation = longitudeLocation
        _id = id
    }
    
    init(eventKey: String, eventData: Dictionary<String, AnyObject>) {
        _eventKey = eventKey
        
        if let eventDate = eventData["Eventdate"] as? String {
            _eventDate = eventDate
        }
        
        if let eventTime = eventData["Eventtime"] as? String {
            _eventTime = eventTime
        }
        
        
        if let recipeCuisine = eventData["Recipecuisine"] as? String {
            _recipeCuisine = recipeCuisine
        }
        
        if let recipeName = eventData["Recipename"] as? String {
            _recipeName = recipeName
        }
        
        if let recipePrice = eventData["Recipeprice"] as? String {
            _recipePrice = recipePrice
        }
        
        if let addImage = eventData["addImage"] as? String {
            _addImage = addImage
        }
        
        if let latitudeLocation = eventData["Latitudelocation"] as? Double {
            _latitudeLocation = latitudeLocation
        }
        
        if let longitudeLocation = eventData["Longitudelocation"] as? Double {
            _longitudeLocation = longitudeLocation
        }
        
        if let id = eventData["id"] as? String {
            _id = id
        }
        
        _eventRef = Database.database().reference().child("newEvent").child(_eventKey)
    }
}
