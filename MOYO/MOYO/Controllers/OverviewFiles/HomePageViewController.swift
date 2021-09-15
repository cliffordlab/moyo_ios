//
//  HomePageViewController.swift
//  MOYO
//
//  Created by Corey S on 7/30/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit
import CoreLocation

class HomePageViewController: UITableViewController {

    var nameArray = ([String](), [String](), [String](), [String]())

    let locationManager = CLLocationManager()
    var location: CLLocation?
    

    @IBOutlet weak var logoutOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(DataHolder.token as Any)
        nameArray = getNameArray()
 
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            // process files
             print(fileURLs)
            //post to AWS to correct files
            
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        // Delete file
        do {
            try fileManager.removeItem(atPath: documentsURL.path)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    
        
        //Moyo Mom PI's do not want participants to have access to Log Out or Admin Use Only 
        if DataHolder.study == "MME" {
            logoutOutlet.isHidden = true
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "More Info", style: .plain, target: self, action: #selector(goToMoreInfo))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "More Info", style: .plain, target: self, action: #selector(goToMoreInfo))
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Admin Use Only", style: .plain, target: self, action: #selector(goToStudySettings))
        }
   
        
        if let navBar = self.navigationController?.navigationBar {
            let border = CALayer()
            border.backgroundColor = UIColor.black.cgColor
            border.frame = CGRect(x:0, y: navBar.frame.height - 0.5, width:navBar.frame.width, height: 0.5)
            navBar.layer.addSublayer(border)
        }
    }

    
    @objc func goToMoreInfo() {
        print("go to more info")
        self.performSegue(withIdentifier: "showMoreInfo", sender: self)
    }

    @IBAction func logOutAction(_ sender: UIButton) {
        //Displays popup asking user if they are certain they want to close and exit the app.
        let alertController = UIAlertController(title: "Quit App", message: "Are you sure you want to log out and exit the App?", preferredStyle: .alert)
        
        //This simply dismisses the popup and the user remains on current view.
        let cancelAction = UIAlertAction(title: "NO", style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        
        //This kills the app in the same way as double tapping & swiping up. Logout function code is modified in App Delegate.
        let OKAction = UIAlertAction(title: "YES", style: .default) { (action) in
            AppDelegate.appDelegate?.logout()
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            
        }
    }
    

    @objc func goToStudySettings() {
        print("go to study settings")
        self.performSegue(withIdentifier: "showStudySettings", sender: self)
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Load features depending on study
        nameArray = getNameArray()
        tableView.reloadData()
    }
    
    func getNameArray() -> ([String], [String], [String], [String]) {
        let configObject = ConfigObject.getInstance(name: DataHolder.study!)
        var nameArray = [String]()
        var iconArray = [String]()
        var contentArray = [String]()
        var alertArray = [String]()
        
        if configObject.activity.visible {
            nameArray.append(configObject.activity.name)
            iconArray.append(configObject.activity.icon)
            contentArray.append(configObject.activity.content)
            alertArray.append(configObject.activityAlert.name)
        }
        if configObject.environment.visible {
            nameArray.append(configObject.environment.name)
            iconArray.append(configObject.environment.icon)
            contentArray.append(configObject.environment.content)
            alertArray.append(configObject.environmentAlert.name)
            
        }
            
            if configObject.food.visible {
                nameArray.append(configObject.food.name)
                iconArray.append(configObject.food.icon)
                contentArray.append(configObject.food.content)
                alertArray.append(configObject.foodAlert.name)
            }
            if configObject.moodsurveys.visible {
                nameArray.append(configObject.moodsurveys.name)
                iconArray.append(configObject.moodsurveys.icon)
                contentArray.append(configObject.moodsurveys.content)
                alertArray.append(configObject.moodAlert.name)
                
            }
            
            if configObject.vitals.visible {
                nameArray.append(configObject.vitals.name)
                iconArray.append(configObject.vitals.icon)
                contentArray.append(configObject.vitals.content)
                alertArray.append(configObject.vitalsAlert.name)
            }
        
        
        if configObject.momVitals.visible {
            nameArray.append(configObject.momVitals.name)
            iconArray.append(configObject.momVitals.icon)
            contentArray.append(configObject.momVitals.content)
            alertArray.append(configObject.vitalsAlert.name)
        }
        
        if configObject.momSymptoms.visible {
            nameArray.append(configObject.momSymptoms.name)
            iconArray.append(configObject.momSymptoms.icon)
            contentArray.append(configObject.momSymptoms.content)
            alertArray.append(configObject.momSymptomsAlert.name)
        }
        
        if configObject.symptomsHistory.visible {
            nameArray.append(configObject.symptomsHistory.name)
            iconArray.append(configObject.symptomsHistory.icon)
            contentArray.append(configObject.symptomsHistory.content)
            alertArray.append(configObject.symptomsHistoryAlert.name)
        }
        
        if configObject.vitalsHistory.visible {
            nameArray.append(configObject.vitalsHistory.name)
            iconArray.append(configObject.vitalsHistory.icon)
            contentArray.append(configObject.vitalsHistory.content)
            alertArray.append(configObject.vitalsHistoryAlert.name)
        }
        
        if configObject.momInstructions.visible {
            nameArray.append(configObject.momInstructions.name)
            iconArray.append(configObject.momInstructions.icon)
            contentArray.append(configObject.momInstructions.content)
            alertArray.append(configObject.momInstructionsAlert.name)
        }
        
        if configObject.extractEMR.visible {
            nameArray.append(configObject.extractEMR.name)
            iconArray.append(configObject.extractEMR.icon)
            contentArray.append(configObject.extractEMR.content)
            alertArray.append(configObject.emrAlert.name)
        }
        
        return (nameArray, iconArray, contentArray, alertArray)
            
        }
    
            

    
    override func numberOfSections(in tableView: UITableView) -> Int {
     
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(nameArray.0.count)
        return nameArray.0.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomePageCell", for: indexPath) as! HomePageCell
            // Configure the cell...
         
        cell.menuImage.image = UIImage(named: NSLocalizedString(nameArray.1[indexPath.row], comment: ""))
        print(nameArray.1[indexPath.row])
        cell.menuTitle.text = NSLocalizedString(nameArray.0[indexPath.row].uppercased(), comment: "")
        cell.menuContent.text = NSLocalizedString(nameArray.2[indexPath.row], comment: "")
        
            cell.alertButton.tag = indexPath.row
           cell.alertButton.addTarget(self, action: #selector(onButtonPressed(sender:)), for: .touchUpInside)
            cell.frame.size.height = tableView.frame.size.height / CGFloat(nameArray.3.count)
        
            return cell
        
        
    }

    @objc func onButtonPressed(sender:UIButton) {
  
        let alert = UIAlertController(title: "Why are we collecting this information?", message: NSLocalizedString(nameArray.3[sender.tag], comment: ""), preferredStyle: UIAlertController.Style.alert)

        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }


    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
       return (tableView.frame.size.height - topOffset()) / CGFloat(nameArray.0.count + 1)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
       

        return (tableView.frame.size.height - topOffset()) / CGFloat(nameArray.0.count + 1)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        tableView.deselectRow(at: indexPath, animated: true)
        switch nameArray.0[indexPath.row] {
    
            case "Activity":
                self.performSegue(withIdentifier: "showActivity", sender: self)
            case "Environment":
                self.performSegue(withIdentifier: "showTravel", sender: self)
            case "Food":
                self.performSegue(withIdentifier: "showFoodDiary", sender: self)
            case "Mood Surveys":
                self.performSegue(withIdentifier: "showMood", sender: self)
            case "Vitals":
                self.performSegue(withIdentifier: "showBloodPressure", sender: self)
            case "Record Vitals":
            self.performSegue(withIdentifier: "showMomVitals", sender: self)
            case "Blood Pressure Symptoms":
            self.performSegue(withIdentifier: "showMomSymptoms", sender: self)
            case "Vitals History":
            self.performSegue(withIdentifier: "showVitalsHistory", sender: self)
            case "Symptoms History":
            self.performSegue(withIdentifier: "showSymptomsHistory", sender: self)
            case "Vitals Instructions":
                self.performSegue(withIdentifier: "showMomInstructions", sender: self)
            case "Extract EMR Data":
            self.performSegue(withIdentifier: "showEMRData", sender: self)
            default:
                break
            
        }
        
    }
    
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
    
