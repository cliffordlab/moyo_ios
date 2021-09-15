//
//  MoodViewController.swift
//  MOYO
//
//  Created by Corey S on 8/29/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData


class MoodViewController: UITableViewController {
    
    var configObject = ConfigObject.getInstance(name: DataHolder.study!)
    var surveyArray = ([String](), [String](), [String](), [String]())
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Assessments"
        surveyArray = getSurveyArray()

       // self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "View History", style: .plain, target: self, action: #selector(historyAction))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    
    }
    
    @objc func historyAction() {
        let av = UIAlertController(title: NSLocalizedString("View Survey History", comment: ""),
                                   message: nil,
                                   preferredStyle: .actionSheet)
        let moodSwipe = UIAlertAction(title: NSLocalizedString("Mood Swipe", comment: ""),
                                  style: .default) { (act) in
                                    self.performSegue(withIdentifier: "showSwipeHistory", sender: self)
        }
        let moodZoom = UIAlertAction(title: NSLocalizedString("Mood Survey", comment: ""),
                                style: .default) { (act) in
                                  self.performSegue(withIdentifier: "showZoomHistory", sender: self)
        }

        let phq = UIAlertAction(title: NSLocalizedString("PHQ9 Survey", comment: ""),
                                style: .default) { (act) in
                                   self.performSegue(withIdentifier: "showPHQ9History", sender: self)
        }

        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                   style: .cancel,
                                   handler: nil)
        av.addAction(moodSwipe)
        av.addAction(moodZoom)
        av.addAction(phq)
        av.addAction(cancel)
        self.present(av, animated: true, completion: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    func getSurveyArray() -> ([String], [String], [String], [String]) {
        var nameArray = [String]()
        var iconArray = [String]()
        var pageArray = [String]()
        var alertArray = [String]()
        
        if configObject.moodswipesurvey.visible {
            nameArray.append(configObject.moodswipesurvey.name)
            iconArray.append(configObject.moodswipesurvey.icon)
            pageArray.append(configObject.moodswipesurvey.pageString)
            alertArray.append(configObject.moodSwipeAlert.name)
        }
        if configObject.moodsurvey.visible {
            nameArray.append(configObject.moodsurvey.name)
            iconArray.append(configObject.moodsurvey.icon)
            pageArray.append(configObject.moodsurvey.pageString)
            alertArray.append(configObject.moodSurveyAlert.name)
        }
            
            if configObject.depressionsurvey.visible {
                nameArray.append(configObject.depressionsurvey.name)
                iconArray.append(configObject.depressionsurvey.icon)
                pageArray.append(configObject.depressionsurvey.pageString)
                alertArray.append(configObject.depressionSurveyAlert.name)
                
            }
            if configObject.cardiosurvey.visible {
                nameArray.append(configObject.cardiosurvey.name)
                iconArray.append(configObject.cardiosurvey.icon)
                pageArray.append(configObject.cardiosurvey.pageString)
                alertArray.append(configObject.cardioSurveyAlert.name)
                
            }
            
            if configObject.anxietysurvey.visible {
                nameArray.append(configObject.anxietysurvey.name)
                iconArray.append(configObject.anxietysurvey.icon)
                pageArray.append(configObject.anxietysurvey.pageString)
                alertArray.append(configObject.anxietySurveyAlert.name)
                
            }
            
            if configObject.generalsymptomssurvey.visible {
                nameArray.append(configObject.generalsymptomssurvey.name)
                iconArray.append(configObject.generalsymptomssurvey.icon)
                pageArray.append(configObject.generalsymptomssurvey.pageString)
                alertArray.append(configObject.generalSymtomsAlert.name)
            }
            if configObject.medicationusesurvey.visible {
                nameArray.append(configObject.medicationusesurvey.name)
                iconArray.append(configObject.medicationusesurvey.icon)
                pageArray.append(configObject.medicationusesurvey.pageString)
                alertArray.append(configObject.medicationUseAlert.name)
                
            }
            if configObject.recordmedicationsurvey.visible {
                nameArray.append(configObject.recordmedicationsurvey.name)
                iconArray.append(configObject.recordmedicationsurvey.icon)
                pageArray.append(configObject.recordmedicationsurvey.pageString)
                alertArray.append(configObject.medicationForgetAlert.name)
                
            }
        return (nameArray, iconArray, pageArray, alertArray)
        }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
   
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        surveyArray.0.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "MoodCell", for: indexPath) as! MoodCell
                cell.menuImage.image = UIImage(named: NSLocalizedString(surveyArray.1[indexPath.row], comment: ""))
                cell.menuTitle.text = NSLocalizedString(surveyArray.0[indexPath.row].uppercased(), comment: "")
    
        
        cell.alertButton.tag = indexPath.row
        cell.alertButton.addTarget(self, action: #selector(onButtonPressed(sender:)), for: .touchUpInside)
        cell.frame.size.height = tableView.frame.size.height / CGFloat(surveyArray.3.count)
        
        return cell
       
    }
    
    @objc func onButtonPressed(sender:UIButton) {

        
        let alert = UIAlertController(title: "Why are we collecting this information?", message: NSLocalizedString(surveyArray.3[sender.tag], comment: ""), preferredStyle: UIAlertController.Style.alert)

        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))


        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
//
//
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return (tableView.frame.size.height) / CGFloat(surveyArray.0.count)
//    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.frame.size.height - topOffset()) / CGFloat(surveyArray.0.count)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: surveyArray.2[indexPath.row], sender: self)

    }
}
