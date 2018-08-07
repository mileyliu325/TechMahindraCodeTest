//
//  GlobleVariable.swift
//  TechMahindraCodeTest
//
//  Created by Simeng Liu on 4/8/18.
//  Copyright © 2018 Simeng Liu. All rights reserved.
//

import Foundation


func isFirstRunApp()->Bool{
    
    var isFirstRun = false
    let keyHasLaunchedBefore = "hasLaunchedBefore"
    
    let hasLaunchBefore = UserDefaults.standard.bool(forKey: keyHasLaunchedBefore)
    
    if hasLaunchBefore{
        print("NOT FIRST")
        isFirstRun = false
    }
    else{
        isFirstRun = true
        print("FIRST")
        UserDefaults.standard.set(true, forKey: keyHasLaunchedBefore)
    }
    return isFirstRun
    
}

func kelvinToCelsius(kelvin:Double) -> Int{
    let celsuisDouble = kelvin-273.15
    let celsuisInt = Int(celsuisDouble)
    let diff = celsuisDouble - Double(celsuisInt)
    
    if diff > 0.5{
        let converstion = celsuisInt + 1
        return converstion
    }
    else{
        return celsuisInt
        
    }
    
}

var APIKey = "d0482d94c7bb0bd1d8f1c9ab2055db83"
var IDs = ["4163971", "2147714", "2174003"]


