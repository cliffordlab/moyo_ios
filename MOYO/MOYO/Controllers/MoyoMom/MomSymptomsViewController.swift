//
//  MomSymptomsViewController.swift
//  MOYO
//
//  Created by Whitney Bremer on 6/8/21.
//  Copyright © 2021 Clifford Lab. All rights reserved.
//

import UIKit
import ResearchKit
import KRProgressHUD
import CoreData

class MomSymptomsViewController: UIViewController, ORKTaskViewControllerDelegate  {
    var resultsArray = [String: String]()
    
    
    let keys: [String:String] = [
        "HeadacheStep": "severe headache",
        "VisionStep": "blurry vision",
        "PainStep": "pain in ribs",
        "BreathingStep": "difficulty breathing"
        
    ]
    
    var trueAnswers: [Bool] = []
    
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        dismiss(animated: true, completion: nil)
        taskViewController.modalPresentationStyle = .popover
                   guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                   let managedContext = appDelegate.persistentContainer.viewContext
                   let symptomSurveyEntity = NSEntityDescription.entity(forEntityName: "SymptomSurvey", in: managedContext)!
                   let symptomSurvey = NSManagedObject(entity: symptomSurveyEntity, insertInto: managedContext)

        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d y"
        
        if reason == .completed {
            for (key,_) in keys {
                self.resultsArray[key] = gatherSymptomData(stepIdentifier: key, viewControllerToPresent: taskViewController)

            }
            
            
            var firstLine = String()
            var secondLine = String()
            var thirdLine = String()

            
            if resultsArray.isEmpty{
                print("Empty array")
            }
            resultsArray.forEach { key, value in
                firstLine.append(key)
                if value == "true" {
                    thirdLine.append(keys[key]!)
                    thirdLine.append(", ")
                }
                firstLine.append(",")
                secondLine.append("\(value)")
                secondLine.append(",")
                let aString = NSString(string: value)
                trueAnswers.append(aString.boolValue)
                print(trueAnswers)
            }
            print("Here are values", trueAnswers)
            firstLine =  firstLine.trimmingCharacters(in: CharacterSet.init(charactersIn: ","))
            secondLine = secondLine.trimmingCharacters(in: CharacterSet.init(charactersIn: ","))
                           symptomSurvey.setValue(today, forKeyPath: "reportedDate")
                           if thirdLine.isEmpty {
                               symptomSurvey.setValue("No Symptoms", forKeyPath: "reportedSymptoms")
                           } else {
                            symptomSurvey.setValue(thirdLine.dropLast(2), forKeyPath: "reportedSymptoms")
                            print("FJSDFKSJKLDJFKDSFHDJKSFHDSJKHF")
                            print(thirdLine.dropLast(2))
                           }
                           do {
                              try managedContext.save()
                              print("Data saved")
                          } catch let error as NSError {
                              print("Could not save. \(error), \(error.userInfo)")
                          }
            
            let resultFile = firstLine + "\n" + secondLine
            let (_, millis) = formattedDateAndMillis()
            
            if let user = DataHolder.userID, let data = resultFile.data(using: .utf8) {
                let fileName = "\(user)_\(millis)_iOS_symptoms.csv"
                
                KRProgressHUD.show(withMessage:NSLocalizedString("Saving sypmtoms..", comment: ""), completion: nil)

                
                API.default.uploadSymptoms(millis: formattedWeeklyMillis(), data: data, fileName: fileName, headache:trueAnswers[0], blurred_vision:trueAnswers[1],side_pain: trueAnswers[2], difficulty_breathing: trueAnswers[3], created_at: millis, completion: { (result) in
                    print("result data sending: \(result)")
                    switch result {
                    case let .Error(message):
                        KRProgressHUD.dismiss()
                        print("Here is result^^^")
                        self.showError(message: message)
                    case .Success:
                        KRProgressHUD.dismiss()
                        print("result data sending: \(result)")
                        print("Here is result^^^")
                        AppDelegate.appDelegate?.scheduleBloodNotification()
                        
                        if secondLine.contains("true") {
                            self.showCallAlert(symptoms: String(thirdLine.dropLast(2)))
                        } else {
                            
                            let alert = UIAlertController(title: NSLocalizedString("Vitals Recorded Successfully", comment: ""),
                                                          message:"Please upload again after 12 hours.",
                                                          preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                self.navigationController?.backToViewController(viewController: HomePageViewController.self)
                            }))
                            
                        }
                        
                    }
                    
                }
                )
                
            }
            
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func startSurvey(_ sender: UIButton) {
        let taskViewController = ORKTaskViewController(task: SymptomTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }

    func showCallAlert(symptoms: String) {
         let alertController = UIAlertController(title: "Symptoms Recorded", message: "Warning: These symptoms may be serious. You should contact your doctor as soon as possible due to: \(symptoms)", preferredStyle: .alert)

        let callAction = UIAlertAction(title: "Call Grady Nurse", style: UIAlertAction.Style.default) {
                               UIAlertAction in
                               NSLog("Call Pressed")
                              guard let number = URL(string: "tel://4046160600") else { return }
                              UIApplication.shared.open(number)
                              self.navigationController?.popViewController(animated: true)
                           }
               alertController.addAction(callAction)
               alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: { action in
                   //Provide user with info on BP info collection.
                   self.cancelAlert()
               }))


                    // Present the controller
               self.present(alertController, animated: true, completion: nil)
    }
    
    func cancelAlert() {
         let alertController = UIAlertController(title: "Why did you click Dismiss?", message: "", preferredStyle: .alert)
        _ = UIAlertAction(title: "I entered my symptoms incorrectly", style: UIAlertAction.Style.default) {
                              UIAlertAction in
                              let taskViewController = ORKTaskViewController(task: SymptomTask, taskRun: nil)
                                            taskViewController.modalPresentationStyle = .fullScreen
                                            taskViewController.navigationBar.prefersLargeTitles = false
                                            taskViewController.navigationBar.backgroundColor = UIColor.clear
                                            taskViewController.delegate = self
                                            self.present(taskViewController, animated: true, completion: nil)
               }

        let mistakeAction = UIAlertAction(title: "I clicked dimiss by mistake", style: UIAlertAction.Style.default) {
                               UIAlertAction in
                    self.showCallAlert(symptoms: "")
                }
               alertController.addAction(mistakeAction)
               alertController.addAction(UIAlertAction(title: "I do not feel like talking", style: UIAlertAction.Style.default, handler: { action in
                   //Transition to Reasons Why VC 
                   self.performSegue(withIdentifier: "showReasons", sender: self)
               }))
                    // Present the controller
               self.present(alertController, animated: true, completion: nil)
    }
    
    

    
    func gatherSymptomData(stepIdentifier: String, viewControllerToPresent: ORKTaskViewController) -> String? {
        print("Survey Complete")
        let taskResultValue = viewControllerToPresent.result
        print(taskResultValue)
        if let formStepResult = taskResultValue.stepResult(forStepIdentifier: stepIdentifier),
            let formItemResults = formStepResult.results,
            let formFirstResult = formItemResults.last,
            let booleanResult = formFirstResult as? ORKBooleanQuestionResult,
            let booleanAnswer = booleanResult.booleanAnswer {
                       print("Result for question: \(booleanAnswer)")
            return String(booleanAnswer.boolValue)
       }
        return nil
    }
    
    
}

