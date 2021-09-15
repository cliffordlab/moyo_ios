//
//  KCCQ12ViewController.swift
//  MOYO
//
//  Created by Whitney Bremer on 4/26/21.
//  Copyright © 2021 Clifford Lab. All rights reserved.
//

import UIKit
import ResearchKit
import KRProgressHUD
import CoreData

//KCCQ12 Cardio Survey

class KCCQ12ViewController: UIViewController, ORKTaskViewControllerDelegate {


        var totalSum = Int()
        var resultsArray = [String: Int]()
        var keys: [String] = [
            "Showering or Bathing",
            "Walking 1 block on level ground",
            "Hurrying or jogging as if to catch a bus",
            "Over the past 2 weeks how many times did you have swelling in your feet ankles or legs when you woke up in the morning?",
            "Over the past 2 weeks on average how many times has fatigue limited your ability to do what you wanted?",
            "Over the past 2 weeks on average how many times has shortness of breath limited your ability to do what you wanted?",
            "Over the past 2 weeks on average how many times have you been forced to sleep sitting up in a chair or with at least 3 pillows to prop you up because of shortness of breath?",
            "Over the past 2 weeks how much has your heart failure limited your enjoyment of life?",
            "If you had to spend the rest of your life with your heart failure the way it is right now how would you feel about this?",
            "How much does your heart failure affect your lifestyle? Please indicate how your heart failure may have limited your participation in HOBBIES AND RECREATIONAL activities over the past 2 weeks?",
            "How much does your heart failure affect your lifestyle? Please indicate how your heart failure may have limited your participation in HOUSEHOLD activities over the past 2 weeks?",
            "How much does your heart failure affect your lifestyle? Please indicate how your heart failure may have limited your participation in VISITING FRIENDS AND FAMILY over the past 2 weeks?"
        ]
        func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
            dismiss(animated: true, completion: nil)
            
            if reason == .completed {
                keys.forEach({ key in
                    
                    print("Here are keys")
                    print(keys)
                    self.resultsArray[key] = gatherCardioData(stepIdentifier: key, viewControllerToPresent: taskViewController)
                    print(resultsArray)
                })
                var firstLine = String()
                var secondLine = String()
            for i in 0...keys.count-1 {
                         firstLine.append(keys[i])
                         firstLine.append(",")
                secondLine.append("\(resultsArray[keys[i]] ?? 0)")
                         secondLine.append(",")
                     }
                self.calculateScore()
                firstLine = firstLine + "Score"
                secondLine = secondLine + "\(totalSum)"
                let resultFile = firstLine + "\n" + secondLine
                
              calculateScore()
                sendFile(fileName: "kccq12.csv", withString: resultFile) { success in
                    if success {
                     
                        self.navigationController?.popViewController(animated: true)
                    }
                }
           }
        }
        
        func taskViewController(_ taskViewController: ORKTaskViewController, stepViewControllerWillAppear stepViewController: ORKStepViewController) {
        
            stepViewController.backButtonItem?.title = "Back"
        }
        
        
        
        func gatherCardioData(stepIdentifier: String, viewControllerToPresent: ORKTaskViewController) -> Int? {
            print("Survey Complete")
            if let stepResult = viewControllerToPresent.result.stepResult(forStepIdentifier: stepIdentifier),
                let stepResults = stepResult.results,
                let stepFirstResult = stepResults.first,
                let booleanResult = stepFirstResult as? ORKChoiceQuestionResult,
                let booleanAnswer = booleanResult.choiceAnswers {
                print("Result for question: \(booleanAnswer)")
                 return booleanAnswer.first as? Int
        
            }
            return nil
        }
        

        func calculateScore() {
            guard (UIApplication.shared.delegate as? AppDelegate) != nil else { return }

    //        let managedContext = appDelegate.persistentContainer.viewContext
    //        let depressionSurveyEntity = NSEntityDescription.entity(forEntityName: "ZoomSurvey", in: managedContext)!
    //        let depressionSurvey = NSManagedObject(entity: depressionSurveyEntity, insertInto: managedContext)



            let new = resultsArray.sorted(by: <)
            print("Here is results array")
            print(new)
            var sum = 0
            for i in 0...11 {
                print("HERE IS I")
                print(i)
                sum += new[i].value
                print("HERE IS SUM OF ALL VALUES")
                print(sum)
            }
            
    //        Total sum is what we need for history graph.
    //        Scale from 0-24 (minimal to severe)
             totalSum = sum
            print("Here is total sum")
            print(totalSum)
    //        depressionSurvey.setValue(totalSum, forKeyPath: "score")
    //
    //        do {
    //            try managedContext.save()
    //            print("Data saved")
    //        } catch let error as NSError {
    //            print("Could not save. \(error), \(error.userInfo)")
    //        }
        }
        
        
        @IBAction func startSurvey(_ sender: UIButton) {
            let taskViewController = ORKTaskViewController(task: KCCQ12SurveyTask, taskRun: nil)
            taskViewController.delegate = self
            present(taskViewController, animated: true, completion: nil)
        }


}
