//
//  MUQSurveyViewController.swift
//  MOYO
//
//  Created by Whitney Bremer on 3/19/21.
//  Copyright © 2021 Clifford Lab. All rights reserved.
//

import UIKit
import ResearchKit
import CoreData

class MUQSurveyViewController: UIViewController, ORKTaskViewControllerDelegate {
    var resultsArray = [String: Int]()
    let keys: [String] = [
        "Over the past two weeks how many times did you forget to take your medication?"
    ]
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
    dismiss(animated: true, completion: nil)
        
         if reason == .completed {
             keys.forEach({ key in
                 print("Here are keys")
                 print(keys)
                 self.resultsArray[key] = gatherMUQData(stepIdentifier: key, viewControllerToPresent: taskViewController)
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
             firstLine = firstLine.trimmingCharacters(in: CharacterSet.init(charactersIn: ","))
             secondLine = secondLine.trimmingCharacters(in: CharacterSet.init(charactersIn: ","))
             let resultFile = firstLine + "\n" + secondLine
        
             sendFile(fileName: "muq.csv", withString: resultFile) { success in
                 if success {
                   
                     self.navigationController?.popViewController(animated: true)
                 }
             }
        }
 
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, stepViewControllerWillAppear stepViewController: ORKStepViewController) {
     
         stepViewController.backButtonItem?.title = "Back"
     }
     
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    


    
    func gatherMUQData(stepIdentifier: String, viewControllerToPresent: ORKTaskViewController) -> Int? {
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
    
    
    
    @IBAction func beginMUQSurvey(_ sender: UIButton) {
         let taskViewController = ORKTaskViewController(task: MUQSurveyTask, taskRun: nil)
            taskViewController.delegate = self
            present(taskViewController, animated: true, completion: nil)
        }
}
