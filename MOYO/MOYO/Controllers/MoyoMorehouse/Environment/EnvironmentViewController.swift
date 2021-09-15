//
//  EnvironmentViewController.swift
//  MOYO
//
//  Created by Whitney Bremer on 6/1/21.
//  Copyright © 2021 Clifford Lab. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation


let environmentImages: [String: UIImage] =
    [
        "clear-day": #imageLiteral(resourceName: "forecast_01d"),
        "clear-night": #imageLiteral(resourceName: "forecast_01n"),
        "rain": #imageLiteral(resourceName: "forecast_09d"),
        "snow": #imageLiteral(resourceName: "forecast_13d"),
        "sleet": #imageLiteral(resourceName: "forecast_11n"), // not found icon for sleet
        "wind": #imageLiteral(resourceName: "forecast_11d"), // not found icon for wind
        "fog": #imageLiteral(resourceName: "forecast_11d"), // not found icon for fog
        "cloudy": #imageLiteral(resourceName: "forecast_03d"),
        "partly-cloudy-day": #imageLiteral(resourceName: "forecast_02d"),
        "partly-cloudy-night":  #imageLiteral(resourceName: "forecast_02n")
]

class EnvironmentViewController: UITableViewController {
    
    var locations = [CLLocation]()
    var pollution: EnvironmentData?
    var food: FoodModel?
    var foodFinalResult = Double()
    var airFinalResult = Int()
    var weatherFinalResult = Int()
    let locationController = CLLocationManager()
    var cityLocation: CLLocation?
    var foodIcon: String!
    var foodContent: String!
    var airIcon: String!
    var airContent: String?
    var weatherIcon: String!
    var weatherContent: String!
    
    //let locationController = CLLocationManager()
    
    var items = [NSLocalizedString("Food", comment: ""), NSLocalizedString("Air Quality", comment: ""), NSLocalizedString("Weather", comment: "")]
    var icons = ["food_good","goodair","partly-cloudy-day"]
    var contents = [NSLocalizedString("Summary: Track and measure your daily step data.", comment: ""), NSLocalizedString("Summary: Track and measure your social interaction.", comment: ""),
                    NSLocalizedString("Summary: Find out what's going on around you.", comment: "")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // nav bar border
        if let navBar = self.navigationController?.navigationBar {
            let border = CALayer()
            border.backgroundColor = UIColor.black.cgColor
            border.frame = CGRect(x:0, y: navBar.frame.height - 0.5, width:navBar.frame.width, height: 0.5)
            navBar.layer.addSublayer(border)
        }
        foodIcon = "pizza"
        foodContent = "Searching for food rating..."
        airIcon = "goodair"
        airContent = "Searching for air rating..."
        weatherIcon = "clear-day"
        weatherContent = "Searching for weather rating..."
        
        locationController.delegate = self
        locationController.startUpdatingLocation()
 
       
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(viewIndex))
        // nav bar border
        if let navBar = self.navigationController?.navigationBar {
            let border = CALayer()
            border.backgroundColor = UIColor.black.cgColor
            border.frame = CGRect(x:0, y: navBar.frame.height - 0.5, width:navBar.frame.width, height: 0.5)
            navBar.layer.addSublayer(border)
        }
    }
    
    @objc func viewIndex() {
      //  AppDelegate.appDelegate?.logout()
    }
    
    
//    func updateWeather(location: CLLocation) {
//        let weatherService = WeatherService(APIKey: weatherAPIKey)
//        weatherService.getCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { (currentWeather) in
//            self.weatherContent =  ((currentWeather?.summary)!) + " (" + String(((currentWeather?.temperature)!)) + "°)"
//            self.weatherIcon =  currentWeather?.icon
//            print(self.weatherIcon!)
//
//            
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
// 
//        }
//
//    }
    
    func updateWeather(location: CLLocation) {
        let mohsenService = EnvironmentService()
        mohsenService.getCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude){  (currentWeather) in
            self.pollution = currentWeather
            print("HERE IT IS \(String(describing: self.pollution?.TEMP!))")
            
            if(self.pollution !== nil){
                self.weatherFinalResult = (self.pollution!.TEMP)!
                print(self.weatherFinalResult)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
          
        }

    }
    
    func updatePollution(location: CLLocation) {
        let mohsenService = EnvironmentService()
        mohsenService.getPullution(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude){  (currentPollution) in
            self.pollution =  currentPollution
            print("HERE IT IS \(String(describing: self.pollution?.AQI!))")
            
            if(self.pollution !== nil){
                self.airFinalResult = (self.pollution!.AQI)!
                print(self.airFinalResult)
                self.loadAirImages()
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
       
        }

    }
    
    
    func updateFood(location: CLLocation) {
        let mohsenService = EnvironmentService()
        mohsenService.getFood(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude){  (currentFood) in
            self.food =  currentFood
           // print(currentFood?.food_desertness)
            print("hey Food")
            print(self.food?.food_desertness!)
            self.foodFinalResult = (self.food?.food_desertness)!
            self.loadFoodImages()
            print("yes Food")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        
        }
        
    }
    
    func loadFoodImages() {
        //Replace finalResult with whatever your results * 100 is.
        switch foodFinalResult  {
        case 0...20:
            //Doughnut image
            foodIcon = "dougnut"
            foodContent = "You are currently in an area that is considered a food desert, with very limited access to healthful foods. This may be due to a lack of grocery stores/farmers’ markers and an abundance of processed foods."
        case 21...40:
            //Pizza image
            foodIcon = "pizza"
            foodContent = "You are currently in an area that is considered a food desert, with very limited access to healthful foods. This may be due to a lack of grocery stores/farmers’ markers and an abundance of processed foods."
        case 41...60:
            //Rice image
            foodIcon = "rice"
            foodContent = "You are currently in an area that is considered a borderline food desert. This area has more access to healthful food choices than a food desert but establishments carrying processed foods still may outnumber healthy establishments. "
        case 61...80:
            //Chicken image
            foodIcon = "chicken"
            foodContent = "You are currently in an area that is NOT considered a food desert. This area has plenty of access to healthful foods through grocery stores and various resources such as farmers’ markets. "
        case 81...100:
            //Broc image
            foodIcon = "brocoli"
            foodContent = "You are currently in an area that is NOT considered a food desert. This area has plenty of access to healthful foods through grocery stores and various resources such as farmers’ markets. "
            
        default:
            print("Something went wrong...")
        }
    }
    
    func loadAirImages() {
        //Replace finalResult with whatever your results * 100 is.
        switch airFinalResult  {
        case -1...50:
            //Doughnut image
            airIcon = "goodair"
            airContent = "Good"
        case 51...100:
            //Pizza image
            airIcon = "goodair"
            foodContent = "Moderate"
        case 101...150:
            //Rice image
            airIcon = "badair"
            airContent = "Unhealthy for Sensitive Groups"
        case 151...200:
            //Chicken image
            airIcon = "badair"
            airContent = "Unhealthy"
        case 201...300:
            //Broc image
            airIcon = "badair"
            airContent = "Very Unhealthy"
        case 301...500:
            //Broc image
            airIcon = "badair"
            airContent = "Hazardous "
            
        default:
            print("Something went wrong...")
        }
    }
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EnvironmentPageCell", for: indexPath) as! EnvironmentPageCell
        // Configure the cell...
       

        if(indexPath.row == 0)
        {
             cell.menuImage.image = UIImage(named: foodIcon!)
             print(foodIcon!)
             cell.menuTitle.text = items[indexPath.row]
             cell.menuContent.text = foodContent!
            // print("eat me")
          //   print(cell.menuContent.text)
        }
        else if (indexPath.row == 1)
        {
            cell.menuImage.image = UIImage(named: airIcon)
            cell.menuTitle.text = items[indexPath.row]
            cell.menuContent.text = airContent
        }
        else if (indexPath.row == 2)
        {
            cell.menuImage.image =  UIImage(named: weatherIcon)
            cell.menuTitle.text = items[indexPath.row]
            cell.menuContent.text = weatherContent
           // print("cell+, (/cell.menuTitle.text")
        //    print(cell.menuContent.text
        }

        //cell.menuContent.text = self.weather?.summary
       // print(indexPath.row)
//        /print;(self.weather?.summary)
        //cell.frame.size.height = tableView.frame.size.height / CGFloat(items.count)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.frame.size.height - topOffset()) / CGFloat(items.count)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.frame.size.height - topOffset()) / CGFloat(items.count)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
}

extension EnvironmentViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        self.updateWeather(location: location)
        self.updatePollution(location: location)
        self.updateFood(location: location)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (marks, error) in
            if let error = error {
                self.showError(message: error.localizedDescription)
            }
            else {
            }
        }
        self.locationController.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}
