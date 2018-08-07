//
//  WeatherModel.swift
//  TechMahindraCodeTest
//
//  Created by Simeng Liu on 4/8/18.
//  Copyright © 2018 Simeng Liu. All rights reserved.
//

import Foundation
import ObjectMapper

class WeatherModel: Mappable {
    
    var id: String?
    var name: String?
    var humidity: Double?
    var pressure : Double?
    var icon: String?
    var summary: String?
    var temp_max: Double?
    var temp_min: Double?
    var temp:Double?
    var windspeed:Double?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        humidity <- map["main.humidity"]
        pressure <- map["main.pressure"]
        temp <- map["main.temp"]
        temp_max <- map["main.temp_max"]
        temp_min <- map["main.temp_min"]
        icon <- map["weather.0.icon"]
        summary <- map["weather.0.main"]
        windspeed <- map["wind.speed"]
        
    }
    
}

