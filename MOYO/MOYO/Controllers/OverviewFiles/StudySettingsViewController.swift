//
//  StudySettingsViewController.swift
//  MOYO
//
//  Created by Whitney Bremer on 4/27/21.
//  Copyright © 2021 Clifford Lab. All rights reserved.
//

import UIKit

//TURN ALL SETTINGS OFF/ON FOR ALL STUDIES 

class StudySettingsViewController: UIViewController {
   var configObject = ConfigObject.getInstance(name: DataHolder.study!)
    
    @IBOutlet var featuresSwitch: [UISwitch]!
    
    @IBOutlet var surveySwitch: [UISwitch]!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
         featuresSwitch[0].setOn(configObject.activity.visible, animated: true)
         featuresSwitch[1].setOn(configObject.environment.visible, animated: true)
         featuresSwitch[2].setOn(configObject.food.visible, animated: true)
         featuresSwitch[3].setOn(configObject.moodsurveys.visible, animated: true)
         featuresSwitch[4].setOn(configObject.vitals.visible, animated: true)

         surveySwitch[0].setOn(configObject.moodswipesurvey.visible, animated: true)
         surveySwitch[1].setOn(configObject.moodsurvey.visible, animated: true)
         surveySwitch[2].setOn(configObject.depressionsurvey.visible, animated: true)
         surveySwitch[3].setOn(configObject.cardiosurvey.visible, animated: true)
         surveySwitch[4].setOn(configObject.anxietysurvey.visible, animated: true)
         surveySwitch[5].setOn(configObject.generalsymptomssurvey.visible, animated: true)
         surveySwitch[6].setOn(configObject.medicationusesurvey.visible,animated: true)
         surveySwitch[7].setOn(configObject.recordmedicationsurvey.visible, animated: true)
        
        surveySwitch[8].setOn(configObject.momVitals.visible, animated: true)
        
        surveySwitch[9].setOn(configObject.momSymptoms.visible, animated: true)
    }
 
    @IBAction func applySettings(_ sender: UIButton) {
        
         configObject.activity.visible = featuresSwitch[0].isOn
         configObject.environment.visible = featuresSwitch[1].isOn
         configObject.food.visible = featuresSwitch[2].isOn
         configObject.moodsurveys.visible = featuresSwitch[3].isOn
         configObject.vitals.visible = featuresSwitch[4].isOn
        configObject.moodswipesurvey.visible = surveySwitch[0].isOn
        configObject.moodsurvey.visible = surveySwitch[1].isOn
        configObject.depressionsurvey.visible = surveySwitch[2].isOn
        configObject.cardiosurvey.visible = surveySwitch[3].isOn
        configObject.anxietysurvey.visible = surveySwitch[4].isOn
        configObject.generalsymptomssurvey.visible = surveySwitch[5].isOn
        configObject.medicationusesurvey.visible = surveySwitch[6].isOn
        configObject.recordmedicationsurvey.visible = surveySwitch[7].isOn
        configObject.momVitals.visible = surveySwitch[8].isOn
        configObject.momSymptoms.visible = surveySwitch[9].isOn
        ConfigObject.setObject(conf: configObject)
        
        
        navigationController?.popToRootViewController(animated: true) 

    }
}
