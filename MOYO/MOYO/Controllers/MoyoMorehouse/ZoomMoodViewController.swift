
import UIKit
import ResearchKit
import CoreData

class ZoomMoodViewController: UIViewController, ORKTaskViewControllerDelegate {
    
    var chartValue = [0]
    var sum = 0
    var resultsArray = [String: Int]()
    let keys: [String] = [
        "AnxiousStep", "ElatedStep", "SadStep", "AngryStep","IrritableStep", "EnergeticStep"
    ]
    
    
    
    var resultsArrayTwo = [String: String]()
    let keysTwo: [String] = [
     "StressStep"
    ]
    

    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        dismiss(animated: true, completion: nil)
        
        if reason == .completed {
            keys.forEach({ key in
                self.resultsArray[key] = gatherMoodData(stepIdentifier: key, viewControllerToPresent: taskViewController)
            })
            
         
                keysTwo.forEach({ key in
                    self.resultsArrayTwo[key] = gatherMoodDataTwo(stepIdentifier: key, viewControllerToPresent: taskViewController)
                })
                
            
        
          //  resultsArrayTwo["StressStep"] = gatherMoodDataTwo(stepIdentifier: "StressStep", viewControllerToPresent: taskViewController )
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
            
            self.calculateScores()
            firstLine =  firstLine.trimmingCharacters(in: CharacterSet.init(charactersIn: ","))
            secondLine = secondLine.trimmingCharacters(in: CharacterSet.init(charactersIn: ","))
            let resultFile = firstLine + "\n" + secondLine
            sendFile(fileName: "mz.csv", withString: resultFile) { success in
                if success {
                  //  self.calculateScores()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
    
    func calculateScores() {
        guard (UIApplication.shared.delegate as? AppDelegate) != nil else { return }
        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let zoomSurveyEntity = NSEntityDescription.entity(forEntityName: "ZoomSurvey", in: managedContext)!
//        let zoomSurvey = NSManagedObject(entity: zoomSurveyEntity, insertInto: managedContext)
//
        let new = resultsArray.sorted(by: <)
        for i in 0...5 {
            sum += new[i].value
            print("HERE IS SUM OF ALL VALUES")
            print(sum)
            let chartValue = [sum]
            print("CHART VALUE")
            print(chartValue)
        }
        
        //Total sum is what we need for history graph.
        //Scale from 1-42 (low to high)
        //Passing sum over to next VC
        let totalSum = sum
        print("Here is total sum")
        print(totalSum)
        
//        zoomSurvey.setValue(totalSum, forKeyPath: "score")
//        do {
//            try managedContext.save()
//            print("Data saved")
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
        
    }
    
    func gatherMoodData(stepIdentifier: String, viewControllerToPresent: ORKTaskViewController) -> Int? {
        print("Survey Complete")
        if let stepResult = viewControllerToPresent.result.stepResult(forStepIdentifier: stepIdentifier),
            let stepResults = stepResult.results,
            let stepFirstResult = stepResults.first,
            let booleanResult = stepFirstResult as? ORKScaleQuestionResult,
            let booleanAnswer = booleanResult.scaleAnswer {
            print("Result for question: \(booleanAnswer)")
            return booleanAnswer.intValue
        }
        return nil
    }
    
    
    func gatherMoodDataTwo(stepIdentifier: String, viewControllerToPresent: ORKTaskViewController) -> String?{
        print("Survey Part Two Complete")
        if let stepResult = viewControllerToPresent.result.stepResult(forStepIdentifier: stepIdentifier),
            let stepResults = stepResult.results,
            let stepFirstResult = stepResults.first,
            let booleanResult = stepFirstResult as? ORKChoiceQuestionResult,
            let booleanAnswer = booleanResult.choiceAnswers{
            print("Result for question: \(booleanAnswer)")
            return booleanAnswer.first as? String
        }
        return nil
    }
    
    
    @IBAction func takeSurvey(_ sender: UIButton) {
        let taskViewController = ORKTaskViewController(task: QuestionTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
        
        
    }
    
    
}
