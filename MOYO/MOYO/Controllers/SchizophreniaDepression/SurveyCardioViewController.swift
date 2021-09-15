//
//  SurveyCardioViewController.swift
//  MOYO
//
//  Created by Whitney H on 9/5/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit
import ResearchKit
import KRProgressHUD
import CoreData

//IMPORTANT!!!!!!!!!!!!!!!!!!!!!!!
//THIS IS ACTUALLY THE GAD-7 SURVEY
class SurveyCardioViewController: UIViewController, ORKTaskViewControllerDelegate {
    
    var totalSum = Int()
    var resultsArray = [String: Int]()
    var keys: [String] = [
        "Feeling nervous or anxious or on edge?",
        "Not being able to stop or control worrying?",
        "Worrying too much about different things?",
        "Trouble relaxing?",
        "Being so restless that it is hard to sit still?",
        "Becoming easily annoyed or irritable?",
        "Feeling afraid as if something awful might happen?"
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
            sendFile(fileName: "gad7.csv", withString: resultFile) { success in
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
        for i in 0...6 {
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
        let taskViewController = ORKTaskViewController(task: GAD7SurveyTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    
}
