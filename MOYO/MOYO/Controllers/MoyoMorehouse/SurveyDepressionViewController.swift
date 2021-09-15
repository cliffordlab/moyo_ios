//
//  SurveyDepressionViewController.swift
//  MOYO
//
//  Created by Whitney H on 9/5/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit
import ResearchKit
import CoreData

class SurveyDepressionViewController: UIViewController, ORKTaskViewControllerDelegate {
    
    var totalSum = Int()
    var resultsArray = [String: Int]()
    let keys: [String] = [
        "Little interest or pleasure in doing things?",
        "Feeling down or depressed or hopeless?",
        "Trouble falling or staying asleep or sleeping too much?",
        "Feeling tired or having little energy?",
        "Poor appetite or overeating?",
        "Feeling bad about yourself or that you are a failure or have let yourself or your family down?",
        "Trouble concentrating on things such as reading the newspaper or watching television?",
        "Thoughts that you would be better off dead or of hurting yourself in some way?"
    ]
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        dismiss(animated: true, completion: nil)
        
        if reason == .completed {
            keys.forEach({ key in
                self.resultsArray[key] = gatherDepressionData(stepIdentifier: key, viewControllerToPresent: taskViewController)
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
       
            sendFile(fileName: "phq9.csv", withString: resultFile) { success in
                if success {
                    if self.resultsArray[self.keys[7]] != 0 {
                        self.showAlert()
                    } else{
                        self.navigationController?.popViewController(animated: true)
                        
                    }}
            }
        }
    }
    
    func calculateScore() {
        guard (UIApplication.shared.delegate as? AppDelegate) != nil else { return }
//
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let depressionSurveyEntity = NSEntityDescription.entity(forEntityName: "DepressionSurvey", in: managedContext)!
//        let depressionSurvey = NSManagedObject(entity: depressionSurveyEntity, insertInto: managedContext)
//        
//        
        
        let new = resultsArray.sorted(by: <)
        print(new.count)
        var sum = 0
        for i in 0...7 {
            sum += new[i].value
            print("HERE IS SUM OF ALL VALUES")
            print(sum)
        }
        
        //Total sum is what we need for history graph.
        //Scale from 0-24 (minimal to severe)
        totalSum = sum
        print("Here is total sum")
        print(totalSum)
      //  depressionSurvey.setValue(totalSum, forKeyPath: "score")
//        
//        do {
//            try managedContext.save()
//            print("Data saved")
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
    }
    
    func showAlert() {
         let alertController = UIAlertController(title: "", message: "Thank you for completing this survey. As mentioned in your consent documentation, this is a research assessment and not conducted for clinical purposes. If you have urgent mental health needs, please contact the Georgia Crisis and Access Line at 1-800-715-4225 or 911 for emergency care.", preferredStyle: .alert)


              
               alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                   //Provide user with info on BP info collection.
                   self.dismiss(animated: false, completion: nil)
                 self.navigationController?.popViewController(animated: true)
               }))


                    // Present the controller
               self.present(alertController, animated: true, completion: nil)
    }

    
    
    func gatherDepressionData(stepIdentifier: String, viewControllerToPresent: ORKTaskViewController) -> Int? {
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
    
    @IBAction func startSurvey(_ sender: UIButton) {
        let taskViewController = ORKTaskViewController(task: PHQ9SurveyTask, taskRun: nil)
        //UIView.appearance().backgroundColor = UIColor.lightGray
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    
}
