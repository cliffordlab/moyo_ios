//
//  SymtomsViewController.swift
//  MOYO
//
//  Created by Corey Shaw on 2/25/20.
//  Copyright © 2020 Clifford Lab. All rights reserved.
//


import UIKit
import ResearchKit
import CoreData

class SymptomsViewController: UIViewController, ORKTaskViewControllerDelegate {
    var resultsArray = [String: Int]()
    let keys: [String] = [
       "headacheStep",
        "visionStep",
        "painStep",
        "breathingStep"
    ]
    var randBools = [Bool] ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UILabel.appearance().font = UIFont(name: "Gills Sans", size: 14)
        let taskViewController = ORKTaskViewController(task: SymptomTask, taskRun: nil)
              taskViewController.navigationBar.prefersLargeTitles = false
                taskViewController.modalPresentationStyle = .popover
        
               // or 2) make the bar opaque
              taskViewController.navigationBar.backgroundColor = .white
              //UIView.appearance().backgroundColor = UIColor.lightGray
              taskViewController.delegate = self
              self.present(taskViewController, animated: true, completion: nil)
    }
    

    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        dismiss(animated: true, completion: nil)
        print("Hello, world!")
       
        if reason == .completed {
            keys.forEach({ key in
                self.resultsArray[key] = gatherDepressionData(stepIdentifier: key, viewControllerToPresent: taskViewController)
            })
            var firstLine = String()
            var secondLine = String()
            resultsArray.forEach { key, value in
                firstLine.append(key)
                print("bob")
                firstLine.append(",")
                
                secondLine.append("\(value)")
                print("knight")
                secondLine.append(",")
            }
            firstLine =  firstLine.trimmingCharacters(in: CharacterSet.init(charactersIn: ","))
            secondLine = secondLine.trimmingCharacters(in: CharacterSet.init(charactersIn: ","))
            let resultFile = firstLine + "\n" + secondLine
            print(secondLine)
            sendFile(fileName: "symptoms.csv", withString: resultFile) { success in
                if success {
                    let fileName = "\(DataHolder.userID)_\(formattedWeeklyMillis())_symptoms.csv"
                    API.default.uploadSymptoms(millis: formattedWeeklyMillis(), data: resultFile.data(using: .utf8)!, fileName: fileName, blurred_vision:false, headache: true, side_pain:true, difficulty_breathing: true, created_at: formattedWeeklyMillis(), completion: { (result) in
                                          print("result data sending: \(result)")
                                          switch result {
                                          case let .Error(message):
                                              print("Here is result^^^")
                                              self.showError(message: message)
                                           case .Success:
                                               print("result data sending: \(result)")
                                               print("Here is result^^^")
                                          }
                                    })
//
                    if secondLine.contains("true") {
//                        self.showCallAlert()
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
//    func calculateScore() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let depressionSurveyEntity = NSEntityDescription.entity(forEntityName: "DepressionSurvey", in: managedContext)!
//        let depressionSurvey = NSManagedObject(entity: depressionSurveyEntity, insertInto: managedContext)
//
//
//
//        let new = resultsArray.sorted(by: <)
//        var sum = 0
//        for i in 0...7 {
//            sum += new[i].value
//            print("HERE IS SUM OF ALL VALUES")
//            print(sum)
//        }
//
//        //Total sum is what we need for history graph.
//        //Scale from 0-24 (minimal to severe)
//        let totalSum = sum
//        print("Here is total sum")
//        print(totalSum)
//        depressionSurvey.setValue(totalSum, forKeyPath: "score")
//
//        do {
//            try managedContext.save()
//            print("Data saved")
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//    }
    
    func showCallAlert() {
        let alertController = UIAlertController(title: "Symptoms Recorded", message: "Because you click [Yes] to one or more symptoms, you should call the Grady nurse", preferredStyle: .alert)

        let callAction = UIAlertAction(title: "Call", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        NSLog("Call Pressed")
                       guard let number = URL(string: "tel://4046160600") else { return }
                       UIApplication.shared.open(number)
                       self.navigationController?.popViewController(animated: true)
                    }
        alertController.addAction(callAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))


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
        let taskViewController = ORKTaskViewController(task: SymptomTask, taskRun: nil)
        taskViewController.modalPresentationStyle = UIModalPresentationStyle(rawValue: 0)!
        taskViewController.navigationBar.prefersLargeTitles = false
        //UIView.appearance().backgroundColor = UIColor.lightGray
        taskViewController.delegate = self
        self.present(taskViewController, animated: true, completion: nil)
        
    
    }
    
    
}
