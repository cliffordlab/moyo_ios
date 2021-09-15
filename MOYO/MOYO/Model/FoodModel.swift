//
//  CurrentWeather.swift
//  MOYO
//
//  Created by Corey.S on 7/26/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import Foundation

class FoodModel
{
    let food_desertness: Double?
    
    struct PollutionKeys {
        static let AQI = "AQI"

    }

    init(food_Double:Double)
    {
        if let foodDouble = food_Double as? Double, foodDouble.isFinite {
            food_desertness = foodDouble * 100
        }
        else {
            food_desertness = nil
        }
    }
    
  
    }
    
  
