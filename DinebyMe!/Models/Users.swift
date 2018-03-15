//
//  Users.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 22-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import Foundation
import Firebase

struct Users {
    
    private var _uid: String!
    private var _email: String!
    private var _name : String!
    private var _key: String!
    private var _Ref: DatabaseReference!
    
    var uid: String {
        return _uid
    }
    
    var email: String {
        return _email
    }
    
    var name: String {
        return _name
    }
    
    var key: String {
        return _key
    }
    
    init(uid: String, email: String, name: String) {
        _uid = uid
        _email = email
        _name = name
    }
    
    init(key: String, data: Dictionary<String, AnyObject>) {
        _key = key
        
        if let uid = data["uid"] as? String {
            _uid = uid
        }
        
        if let email = data["email"] as? String {
            _email = email
        }
        
        if let name = data["name"] as? String {
            _name = name
        }
        
        _Ref = Database.database().reference().child("users").child(_key)
    }
}
