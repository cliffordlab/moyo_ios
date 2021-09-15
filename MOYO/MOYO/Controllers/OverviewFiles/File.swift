//
//  File.swift
//  MOYO
//
//  Created by Whitney Bremer on 5/1/21.
//  Copyright © 2021 Clifford Lab. All rights reserved.
//

import Foundation

struct ConfigObject {
    
    private static var shared = ConfigObject()
    private static var name: String? = nil
    var uuid = UUID()
    //Main Menu Features
    var activity = CategoryStruct(name: "Activity", icon: "activity2", content: "Track and measure your daily step data.")
    var environment = CategoryStruct(name: "Environment", icon: "travel2", content: "Find out what's going on around you.")
    var food = CategoryStruct(name: "Food", icon: "food2", content: "Upload and track what you're eating.")
    var moodsurveys = CategoryStruct(name: "Mood Symptoms", icon: "icons8-test-passed", content: "Take various surveys to determine your mood.")
    var vitals = CategoryStruct(name: "Vitals", icon: "bloodpressure2", content: "Upload and track your daily vital signs.")
    var momVitals = CategoryStruct(name: "Record Vitals", icon: "bloodpressure2", content: "Upload and track your daily vital signs.")
    var momSymptoms = CategoryStruct(name: "Blood Pressure Symptoms", icon: "side_pain", content: "Upload and track your symptoms.")
    var momInstructions = CategoryStruct(name:"Vitals Instructions", icon:"info", content: "How to upload vitals")
    var extractEMR = CategoryStruct(name:"Extract EMR Data", icon:"graphicon", content: "")
    
    //Moyo Mom History
    var vitalsHistory = CategoryStruct(name: "Vitals History", icon: "history", content: "View your vitals history.")
    var symptomsHistory = CategoryStruct(name: "Symptoms History", icon: "history", content: "View your symptoms history.")
    
    //Surveys
    var moodswipesurvey = StudySurvey(name: "Mood Picture Swipe Survey", icon: "icons8-happy-filled", pageString: "showMoodSwipe")
    var moodsurvey = StudySurvey(name: "Mood Survey", icon: "icons8-test-passed", pageString: "showMoodZoom")
    var depressionsurvey = StudySurvey(name: "PHQ-9 Depression Questionnaire", icon: "icons8-test-passed", pageString: "showPHQ9")
    var cardiosurvey = StudySurvey(name: "KCCQ-12 Cardio Survey", icon: "icons8-test-passed", pageString: "showKCCQ12")
    var anxietysurvey = StudySurvey(name: "GAD-7 Generalized Anxiety Questionnaire", icon: "icons8-test-passed", pageString: "showGDA7")
    var generalsymptomssurvey = StudySurvey(name: "GSQ General Symptoms Questionnaire", icon: "icons8-test-passed", pageString: "showGSQ")
    var medicationusesurvey = StudySurvey(name: "MUQ Medication Use Questionnaire", icon: "icons8-test-passed", pageString: "showMUQ")
    var recordmedicationsurvey = StudySurvey(name: "Record Medications & How Often You Forget To Take Them", icon: "icons8-test-passed", pageString: "showMeds")
    
    
    //Alerts
    var activityAlert = AlertStruct(name: "Your health is affected by your physical activity. By looking at your step count, you can be aware of your daily activity", comment: "", visible: true)
    
    var environmentAlert = AlertStruct(name: "Your health is affected by your environment. Pollution, weather and food options are big influences on your day to day behaviors and long term health. By looking at your mood and other things this app measures (like movement), you may see a relationship between your environment and your well being", comment: "", visible: true)
    
    var foodAlert = AlertStruct(name: "Your health is affected by what you eat. By taking a photo and writing down what you eat, it helps you make more informed decisions", comment: "", visible: true)
    
    var moodAlert = AlertStruct(name: "By taking these surveys, you will be able to better track your various metrics such as your mood and cardio health.", comment: "", visible: true)
    
    var vitalsAlert = AlertStruct(name: "By taking a photo and selecting the correct blood pressure and heart rate, it helps you to be aware and keep track of your vitals", comment: "", visible: true)
    
    var moodSwipeAlert = AlertStruct(name: "This is a simple emoji based survey to allow you to rapidly describe your mood on a 5-point scale", comment: "", visible: true)
    
    var momSymptomsAlert = AlertStruct(name: "This survey helps you to keep track of any symptoms you may be experiencing", comment: "", visible: true)
    
    var momInstructionsAlert = AlertStruct(name: "This demonstrates how to record your vitals using pictures", comment: "", visible: true)
    
    var symptomsHistoryAlert = AlertStruct(name: "This chart allows you to view your symptoms history over time.", comment: "", visible: true)
    
    var vitalsHistoryAlert = AlertStruct(name: "This chart allows you to view your vitals history over time.", comment: "", visible: true)
    
    var moodSurveyAlert = AlertStruct(name: "This survey was developed to detect mood disorders.", comment: "", visible: true)
    
    var depressionSurveyAlert = AlertStruct(name: "This survey is intended to help clinicians diagnose and monitor depression.", comment: "", visible: true)
    
    var cardioSurveyAlert = AlertStruct(name: "This survey is intended to assess your cardiovascular health.", comment: "", visible: true)
    
    
    var anxietySurveyAlert = AlertStruct(name: "This survey is intended to help clinicians diagnose and monitor symptoms of anxiety.", comment: "", visible: true)
    
    var generalSymtomsAlert = AlertStruct(name: "The General Symptom Questionnaire is a survey designed to help identify if individuals have any odd or unusual experiences", comment: "", visible: true)
    
    var medicationUseAlert = AlertStruct(name: "The Medication Utilization Questionnaire is a survey designed to help clinicians monitor how consistently individuals take their medication(s).", comment: "", visible: true)
    
    var medicationForgetAlert = AlertStruct(name: "The Medication Utilization Questionnaire is a survey designed to help clinicians monitor how consistently individuals take their medication(s).", comment: "", visible: true)
    
    var emrAlert = AlertStruct(name: "This feature allows you to upload your EMR data.", comment: "", visible: true)
               
               
    
    
    
    private init() {}
    
    static func setObject(conf: ConfigObject) {
        shared = conf
    }

    static func getInstance(name: String) -> ConfigObject {
        //UNCOMMENT FOR EMR 
//        shared.extractEMR.visible = true
//        shared.emrAlert.visible = true
        
        print("getInstance")
        if ConfigObject.name == nil {
            ConfigObject.name = name
            switch name {
            
            //The study name MUST match the server response exactly
            case "MME":
                shared.momVitals.visible = true
                shared.momSymptoms.visible = true
                shared.vitalsHistory.visible = true
                shared.symptomsHistory.visible = true
                shared.momInstructions.visible = true
                
                //Alerts
                shared.momSymptomsAlert.visible = true
                shared.vitalsHistoryAlert.visible = true
                shared.symptomsHistoryAlert.visible = true
                shared.momInstructionsAlert.visible = true 
         
                break
                
                case "moyo":
                    shared.activity.visible = true
                    shared.environment.visible = true
                    shared.food.visible = true
                    shared.moodsurveys.visible = true
                    shared.vitals.visible = true
                    shared.moodswipesurvey.visible = true
                    shared.moodsurvey.visible = true
                    shared.depressionsurvey.visible = true
                    
                    shared.activityAlert.visible = true
                    shared.environmentAlert.visible = true
                    shared.foodAlert.visible = true
                    shared.moodAlert.visible = true
                    shared.vitalsAlert.visible = true
                    //Survey Alerts
                    shared.moodSwipeAlert.visible = true
                    shared.moodSurveyAlert.visible = true
                    shared.depressionSurveyAlert.visible = true
              
                    break
                case "hf":
                    shared.activity.visible = true
                    shared.environment.visible = true
                    shared.food.visible = true
                    shared.moodsurveys.visible = true
                    shared.vitals.visible = true
                    shared.moodswipesurvey.visible = true
                    shared.moodsurvey.visible = true
                    shared.depressionsurvey.visible = true
                    shared.cardiosurvey.visible = true
                    
                    shared.activityAlert.visible = true
                    shared.environmentAlert.visible = true
                    shared.foodAlert.visible = true
                    shared.moodAlert.visible = true
                    shared.vitalsAlert.visible = true
                    //Survey Alerts
                    shared.moodSwipeAlert.visible = true
                    shared.moodSurveyAlert.visible = true
                    shared.depressionSurveyAlert.visible = true
                    shared.cardioSurveyAlert.visible = true
                    break
                case "schizo-depression-study":
                    shared.moodsurveys.visible = true
                    shared.depressionsurvey.visible = true
                    shared.anxietysurvey.visible = true
                    shared.generalsymptomssurvey.visible = true
                    shared.medicationusesurvey.visible = true
                    shared.recordmedicationsurvey.visible = true
                    
                    shared.moodAlert.visible = true
    
                    //Survey Alerts
                    shared.depressionSurveyAlert.visible = true
                    shared.medicationUseAlert.visible = true
                    shared.generalSymtomsAlert.visible = true
                    shared.anxietySurveyAlert.visible = true
                    shared.medicationForgetAlert.visible = true
                    
                    break
                default:
                    break
            }
        }
        return shared
    }
}



struct CategoryStruct {
    //Main Page Settings
    var name = ""
    var icon = ""
    var content = ""
    var visible = false

    
}

struct StudySurvey {
    //Mood Surveys
    var name = ""
    var icon = ""
    var visible = false
    var pageString = ""
}


struct AlertStruct {
    //User Info Alerts
    var name = ""
    var comment = ""
    var visible = false
    
}

