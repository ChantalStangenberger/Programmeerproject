//
//  acceptedRequests.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 06-04-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import Foundation
import Firebase

class acceptedRequests {
    private var _eventDate: String!
    private var _eventTime: String!
    private var _recipeCuisine: String!
    private var _recipeName: String!
    private var _recipePrice: String!
    private var _addImage: String!
    private var _latitudeLocation: Double!
    private var _longitudeLocation: Double!
    private var _userid: String!
    private var _hostid: String!
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
    
    var userid: String {
        return _userid
    }
    
    var hostid: String {
        return _hostid
    }
    
    var eventKey: String {
        return _eventKey
    }
    
    init(eventDate: String, eventTime: String, recipeCuisine: String, recipeName: String, recipePrice: String, addImage: String, latitudeLocation: Double, longitudeLocation: Double, userid: String, hostid: String) {
        _eventDate = eventDate
        _eventTime = eventTime
        _recipeCuisine = recipeCuisine
        _recipeName = recipeName
        _recipePrice = recipePrice
        _addImage = addImage
        _latitudeLocation = latitudeLocation
        _longitudeLocation = longitudeLocation
        _userid = userid
        _hostid = hostid
    }
    
    init(eventKey: String, eventData: Dictionary<String, AnyObject>) {
        _eventKey = eventKey
        
        if let eventDate = eventData["Eventdate"] as? String {
            _eventDate = eventDate
        }
        
        if let eventTime = eventData["Eventtime"] as? String {
            _eventTime = eventTime
        }
        
        
        if let recipeCuisine = eventData["Cuisine"] as? String {
            _recipeCuisine = recipeCuisine
        }
        
        if let recipeName = eventData["Recipename"] as? String {
            _recipeName = recipeName
        }
        
        if let recipePrice = eventData["Price"] as? String {
            _recipePrice = recipePrice
        }
        
        if let addImage = eventData["Image"] as? String {
            _addImage = addImage
        }
        
        if let latitudeLocation = eventData["latitude"] as? Double {
            _latitudeLocation = latitudeLocation
        }
        
        if let longitudeLocation = eventData["longitude"] as? Double {
            _longitudeLocation = longitudeLocation
        }
        
        if let userid = eventData["Userid"] as? String {
            _userid = userid
        }
        
        if let hostid = eventData["Hostid"] as? String {
            _hostid = hostid
        }
        
        _eventRef = Database.database().reference().child("acceptedRequests").child(_eventKey)
    }
}
