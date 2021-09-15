//
//  GSQSurveyViewController.swift
//  MOYO
//
//  Created by Whitney Bremer on 3/19/21.
//  Copyright © 2021 Clifford Lab. All rights reserved.
//

import UIKit
import ResearchKit
import CoreData

class GSQSurveyViewController: UIViewController, ORKTaskViewControllerDelegate {
    
    var totalSum = Int()
    var resultsArray = [String: Int]()
    let keys: [String] = [
        "In the last THREE DAYS I have taken my medications as scheduled",
        "Today I have heard voices or saw things others cannot",
        "Today I have thoughts racing through my head",
        "Today I feel I have special powers",
        "Today I feel people are watching me",
        "Today I feel people are againt me",
        "Today I feel consumed or puzzled",
        "Today I feel unable to cope and have difficulty with everyday tasks",
        "In the last THREE DAYS during the daytime I have gone outside my home",
        "In the last THREE DAYS I have preferred to spend time alone",
        "In the last THREE DAYS I have had arguments with other people",
        "In the last THREE DAYS I have had someone to talk to",
        "In the last THREE DAYS I have felt uneasy with groups of people",
        "How much exercise have you gotten today?",
        "How did you feel this week?",
        "Have you been admitted to the hospital for psychiatric reasons?",
       
    ]
    
    
    var resultsArrayTwo = [String: String]()
    let keysTwo: [String] = [
     "Use this space to enter your thoughts and feeling about this week"
    ]
    
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
           dismiss(animated: true, completion: nil)
        
        if reason == .completed {
               keys.forEach({ key in
                   self.resultsArray[key] = gatherGSQIntData(stepIdentifier: key, viewControllerToPresent: taskViewController)
               })
            
            
            keysTwo.forEach({ key in
                self.resultsArrayTwo["Use this space to enter your thoughts and feeling about this week"] = gatherGSQStringData(stepIdentifier: "Use this space to enter your thoughts and feeling about this week", viewControllerToPresent: taskViewController )
            })
        
               var firstLine = String()
               var secondLine = String()
            
           for i in 0...keys.count-1 {
                        firstLine.append(keys[i])
                        firstLine.append(",")
            secondLine.append("\(resultsArray[keys[i]] ?? 0)")
                        secondLine.append(",")
                    }
            
            for i in 0...keysTwo.count-1 {
                firstLine.append(keysTwo[i])
                firstLine.append(",")
                secondLine.append("\(resultsArrayTwo[keysTwo[i]] ?? "0")")
                secondLine.append(",")
            }
            
             self.calculateScore()
            
            firstLine =  firstLine + "Score"
            secondLine = secondLine + "\(totalSum)"
               let resultFile = firstLine + "\n" + secondLine
               sendFile(fileName: "gsq.csv", withString: resultFile) { success in
                   if success {
                   
                       self.navigationController?.popViewController(animated: true)
                   }
               }
           }
        
    }
    

    func gatherGSQStringData(stepIdentifier: String, viewControllerToPresent: ORKTaskViewController) -> String? {
           print("Survey Complete")
           if let stepResult = viewControllerToPresent.result.stepResult(forStepIdentifier: stepIdentifier),
               let stepResults = stepResult.results,
               let stepFirstResult = stepResults.first,
               let freeTextResult = stepFirstResult as? ORKTextQuestionResult,
            let freeTextAnswer = freeTextResult.textAnswer {
            print("HERE IS FREE TEXT ANSWER")
            print(stepResults)
            print(freeTextAnswer)
            return freeTextAnswer
        }
    
           return nil
       }
    
    func gatherGSQIntData(stepIdentifier: String, viewControllerToPresent: ORKTaskViewController) -> Int? {
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, stepViewControllerWillAppear stepViewController: ORKStepViewController) {
    
        stepViewController.backButtonItem?.title = "Back"
    }
    
        func calculateScore() {
            guard (UIApplication.shared.delegate as? AppDelegate) != nil else { return }
//
//            let managedContext = appDelegate.persistentContainer.viewContext
//            let generalSurveyEntity = NSEntityDescription.entity(forEntityName: "GSQSurvey", in: managedContext)!
//            let generalSurvey = NSManagedObject(entity: generalSurveyEntity, insertInto: managedContext)
//


            let new = resultsArray.sorted(by: <)
            print("Here is results array")
            print(new)
            var sum = 0
            for i in 0...15 {
                print("HERE IS I")
                print(i)
                sum += new[i].value
                print("HERE IS SUM OF ALL VALUES")
                print(sum)
            }
            
            totalSum = sum
            print("Here is total sum")
            print(totalSum)
          //  generalSurvey.setValue(totalSum, forKeyPath: "score")
            
//            do {
//                try managedContext.save()
//                print("Data saved")
//            } catch let error as NSError {
//                print("Could not save. \(error), \(error.userInfo)")
//            }
       }
    
    @IBAction func beginGSQSurvey(_ sender: UIButton) {
        let taskViewController = ORKTaskViewController(task: GSQSurveyTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }

}
