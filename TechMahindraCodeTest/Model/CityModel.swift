//
//  CityModel.swift
//  TechMahindraCodeTest
//
//  Created by Simeng Liu on 7/8/18.
//  Copyright © 2018 Simeng Liu. All rights reserved.
//

import Foundation
import ObjectMapper

class CityModel: Mappable {
    
    var country: String?
    var id: Int?
    var name : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        country <- map["country"]
        name <- map["name"]
    }
    
}

