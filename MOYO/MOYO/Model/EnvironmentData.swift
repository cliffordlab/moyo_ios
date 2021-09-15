//
//  EnvironmentData.swift
//  MOYO
//
//  Created by Whitney Bremer on 8/11/21.
//  Copyright © 2021 Clifford Lab. All rights reserved.
//


import Foundation

class EnvironmentData {
    
    var AQI: Int?
    var TEMP: Int?


    
    struct PollutionKeys {
        static let AQI = "AQI"

    }
    
    
    struct WeatherKeys {
        static let TEMP = "temperature"
    }

    
    init(pollutionDictionary: [String : Any])
    {
        if let aqi = pollutionDictionary[PollutionKeys.AQI] as? Double, aqi.isFinite {
            AQI = Int(round(aqi))
        }
        else {
            AQI = nil
        }
        
    }
    
    

    init(weatherDictionary: [String : Any])
    {
        if let temp = weatherDictionary[WeatherKeys.TEMP] as? Double, temp.isFinite {
            TEMP = Int(round(temp))
        }
        else {
            TEMP = nil
        }

    }



    
}
