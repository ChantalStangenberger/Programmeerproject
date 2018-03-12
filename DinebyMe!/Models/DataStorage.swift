//
//  SendData.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 10-03-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import Foundation

class DataStorage {
    var sharedInstance: DataStorage {
        struct Static {
            static let instance = DataStorage()
        }
        return Static.instance
    }
    var recipename : String = ""
    var recipedate : String = ""
    var recipeprice : String = ""
    var id : String = ""
}
