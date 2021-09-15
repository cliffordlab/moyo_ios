//
//  EnvironmentService.swift
//  MOYO
//
//  Created by Whitney Bremer on 8/9/21.
//  Copyright © 2021 Clifford Lab. All rights reserved.
//


import Foundation
import Alamofire
import SwiftyJSON

class EnvironmentService
{

    
    let environmentBaseURL: URL?
    
    init()
    {
        environmentBaseURL = URL(string: ENVIRONMENT_URL)
    }
    
    func getPullution(latitude: Double, longitude: Double, completion: @escaping (EnvironmentData?) -> Void)
    {
        if let pollutionURL = URL(string: "\(environmentBaseURL!)\(latitude)") {
            let req = Alamofire.request(pollutionURL,
                                        method: .get,
                                        parameters: [
                                            "long":longitude,
                                        ],
                                        encoding: URLEncoding.default,
                                        headers: nil).responseJSON(completionHandler: { (response) in
                if let jsonDictionary = response.result.value as? [String : Any] {
                    if let pollutionDictionary = jsonDictionary["pollution"] as? [String : Any] {
                        let pollution = EnvironmentData(pollutionDictionary: pollutionDictionary)
                        completion(pollution)
                        print(pollution)
                        return
                    }
                }
                completion(nil)
            })
           print(req)
        }
        
    }
    
    
    func getCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (EnvironmentData?) -> Void)
    {
        if let pollutionURL = URL(string: "\(environmentBaseURL!)\(latitude)") {
            let req = Alamofire.request(pollutionURL,
                                        method: .get,
                                        parameters: [
                                            "long":longitude,
                                        ],
                                        encoding: URLEncoding.default,
                                        headers: nil).responseJSON(completionHandler: { (response) in
                if let jsonDictionary = response.result.value as? [String : Any] {
                    if let pollutionDictionary = jsonDictionary["weather"] as? [String : Any] {
                        let pollution = EnvironmentData(weatherDictionary: pollutionDictionary)
                        completion(pollution)
                        print(pollution)
                        return
                    }
                }
                completion(nil)
            })
           print(req)
        }
    }
    
    
    func getFood(latitude: Double, longitude: Double, completion: @escaping (FoodModel?) -> Void)
    {
        if let mohsenURL = URL(string: "\(environmentBaseURL!)\(latitude)") {
            let req = Alamofire.request(mohsenURL,
                                        method: .get,
                                        parameters: [
                                            "long":longitude,
                                            ],
                                        encoding: URLEncoding.default,
                                        headers: nil).responseJSON(completionHandler: { (response) in
                                            switch response.result {
                                            case .success(let value):
                                                let json = JSON(value)
                                                let foodJson = json["desertiness_index"]
                                                print(foodJson)
                                                let foodDouble = foodJson.doubleValue
                                                print(foodDouble)
                                                let foodDesert = FoodModel(food_Double: foodDouble)
                                                print(foodDesert)
                                                completion(foodDesert)
                                            case .failure(let error):
                                             print(error.localizedDescription)
                                            }
                                            
                                        })
            print(req)
        }
        
    }
    
    
}

