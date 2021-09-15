//
//  BloodPressureViewController.swift
//  MOYO
//
//  Created by Corey S on 9/11/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit
import KRProgressHUD
import ResearchKit
import CoreData

class BloodPressureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, ORKTaskViewControllerDelegate {
    
    
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var pressureValue: UIPickerView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var submitButtonRight: UIButton!
    
    var resultsArray = [String: Int]()
       let keys: [String] = [
           "HeadacheStep",
           "VisionStep",
           "PainStep",
           "BreathingStep"
       ]
    
    @IBAction func backButton(_ sender: UIButton) {
        print("Attempting to go back ")
        self.dismiss(animated: false, completion: nil)
    }
    
    let defaults = UserDefaults.standard
    
    let picker = UIImagePickerController()
    let choicePicker = UIPickerView()
    //Content for picker views.
    let systolicData = [Int](29...300)
    let diastolicData = [Int](29...300)
    let pulseData = [Int](34...221)
    var imageTimer: Timer?
    var chosenImage: UIImage? = nil {
        didSet {
            if chosenImage != nil{
                pressureValue.isUserInteractionEnabled = true
                pressureValue.alpha = 1
            }
        }
    }
    func enableButton() {
        submitButton.alpha = 1
        submitButton.alpha = 1
        defaults.set(false, forKey: "rightSubmitted")
        defaults.set(false, forKey: "leftSubmitted")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        title = NSLocalizedString("Record Vitals", comment: "")
        picker.delegate = self
        pressureValue.alpha = 0.5
        pressureValue.delegate = self
        pressureValue.selectRow(0, inComponent: 0, animated: false)
        pressureValue.selectRow(0, inComponent: 1, animated: false)
        pressureValue.selectRow(0, inComponent: 2, animated: false)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "info"), style: .plain, target: self, action: #selector(instructionsAction))
        
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(goToSettings))
        
        
        // nav bar border
        if let navBar = self.navigationController?.navigationBar {
            let border = CALayer()
            border.backgroundColor = UIColor.black.cgColor
            border.frame = CGRect(x:0, y: navBar.frame.height - 0.5, width:navBar.frame.width, height: 0.5)
            navBar.layer.addSublayer(border)
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        submitButton.isEnabled = true
        submitButtonRight.isEnabled = true 
        if (defaults.bool(forKey: "rightSubmitted") == true && defaults.bool(forKey: "leftSubmitted")) == true {
                  enableButton()
              }
              
        
        if defaults.bool(forKey: "rightSubmitted") == true {
            submitButtonRight.alpha = 0.5
        }
        
        if defaults.bool(forKey: "leftSubmitted") == true {
            submitButton.alpha = 0.5
        }
        
 
             
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ReportedVitals")
                  let sortDescriptor = NSSortDescriptor(key: "reportedDate", ascending: false)
                  fetchRequest.sortDescriptors = [sortDescriptor]
                  fetchRequest.fetchLimit = 1
                  
                  do {
                     guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                      let managedContext = appDelegate.persistentContainer.viewContext
                      let records = try managedContext.fetch(fetchRequest) as! [NSManagedObject]

                      for record in records {
                          let lastreportedArm = record.value(forKey: "arm" )as? String
                        print(lastreportedArm)
                        if (lastreportedArm == "right")
                            {
                                print("Right arm already reported once")
                            }
                        if (lastreportedArm == "left")
                        {
                         print("Left arm already reported once ")
                        }
                        
                            
                
                      }

                  } catch {
                      print(error)
                  }
          }
    
  

       
    @objc func logoutAction() {
        //Displays popup asking user if they are certain they want to close and exit the app.
        let alertController = UIAlertController(title: "Kill App", message: "Are you sure you want to exit and close the App?", preferredStyle: .alert)
        
        //This simply dismisses the popup and the user remains on current view.
        let cancelAction = UIAlertAction(title: "NO", style: .cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        
        //This kills the app in the same way as double tapping & swiping up. Logout function code is modified in App Delegate.
        let OKAction = UIAlertAction(title: "YES", style: .default) { (action) in
            AppDelegate.appDelegate?.logout()
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            
        }
        
    }
    
    @objc func goToSettings() {
        if let url = URL(string:UIApplicationOpenSettingsURLString)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func instructionsAction() {
       self.performSegue(withIdentifier: "showWTInstructions", sender: self)
    }
    
    
    @IBAction func photoFromLibrary(_ sender: UIButton) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func shootPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            picker.delegate = self
            present(picker, animated: false, completion: nil)
            
        }
    }
    
    @IBAction func takeAction(_ sender: Any) {
        self.shootPhoto(UIButton())
    }
    
    func takeActionFromAlert(){
      self.shootPhoto(UIButton())
    }
    
    
    func validatePressure() -> Bool{
        let selectedSysValue = systolicData[pressureValue.selectedRow(inComponent: 0)]
        let selectedDiaValue = diastolicData[pressureValue.selectedRow(inComponent: 1)]
        
        if selectedDiaValue >= selectedSysValue {
            return false
        }
        return true
    }
    
    func emptyValues(arm: String) {
        let selectedSysValue = systolicData[pressureValue.selectedRow(inComponent: 0)]
        let selectedDiaValue = diastolicData[pressureValue.selectedRow(inComponent: 1)]
        let selectedPulse = pulseData[pressureValue.selectedRow(inComponent: 2)]
        //For BP
        let alert = UIAlertController(title: "No Photo", message: "Please take a picture of your vitals.", preferredStyle: UIAlertController.Style.alert)
        
        
        
        //Dimisses popup so user can enter vitals.
        alert.addAction(UIAlertAction(title: "Ok, I'll add a photo", style: UIAlertAction.Style.default, handler:  { action in
                   //Provide user with info on BP info collection.
                   self.takeActionFromAlert()
       }))
        alert.addAction(UIAlertAction(title: "Learn More", style: UIAlertAction.Style.default, handler: { action in
            //Provide user with info on BP info collection.
            self.bpAlert(arm: arm)
        }))
        
        alert.addAction(UIAlertAction(title: "Skip, I don't want to add a photo", style: UIAlertAction.Style.default, handler: { action in
              //Take user back to main page here & sends recorded info, if any.
               self.sendPressureWithoutImage(systolic: selectedSysValue, diastolic: selectedDiaValue, pulse: selectedPulse, arm: arm)
        }))
              
        self.present(alert, animated: true, completion: nil)
    }
    
    func bpAlert(arm: String) {
        let selectedSysValue = systolicData[pressureValue.selectedRow(inComponent: 0)]
        let selectedDiaValue = diastolicData[pressureValue.selectedRow(inComponent: 1)]
        let selectedPulse = pulseData[pressureValue.selectedRow(inComponent: 2)]
        
        //For BP
        let alert = UIAlertController(title: "Why are we collecting this info?", message: "Blood pressure and heart rate are important signs of wellness. By sharing your vitals you help doctors check your health.", preferredStyle: UIAlertController.Style.alert)
        
        
        //Take user back to BP page to enter their info.
        alert.addAction(UIAlertAction(title: "Ok, I'll add a photo ", style: UIAlertAction.Style.default, handler:  { action in
                          //Provide user with info on BP info collection.
                          self.takeActionFromAlert()
              }))
        
        alert.addAction(UIAlertAction(title: "Skip, I don't want to add a photo", style: UIAlertAction.Style.default, handler: { action in
            //Take user back to main page here & send any recorded info.
//            let (formattedDate, millis) = formattedDateAndMillis()
//            let (weeklyMilis) = formattedWeeklyMillis()
//
//            let today = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d y"
            
            self.sendPressureWithoutImage(systolic: selectedSysValue, diastolic: selectedDiaValue, pulse: selectedPulse, arm: arm)
            
            
            
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func showCallAlert() {
        
         let alertController = UIAlertController(title: "Vitals Recorded", message: "Warning: Your blood pressure may be high. Please schedule an appointment with your doctor.", preferredStyle: .alert)


               alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
                      self.navigationController?.popViewController(animated: true)
                  }))

                    // Present the controller
               self.present(alertController, animated: true, completion: nil)
     
    }
    
    func showCallAlertTwo() {
        
         let alertController = UIAlertController(title: "Vitals Recorded", message: "Warning: Your blood pressure may be low. Please schedule an appointment with your doctor.", preferredStyle: .alert)

               alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
                      self.navigationController?.popViewController(animated: true)
                  }))

                    // Present the controller
               self.present(alertController, animated: true, completion: nil)
     
    }
    
    func showCallAlertThree() {
         let alertController = UIAlertController(title: "Vitals Recorded", message: "Warning: Your blood pressure may be high. Please sit quietly for 15 minutes and check your blood pressure again.", preferredStyle: .alert)

               alertController.addAction(UIAlertAction(title: "Dimiss", style: .default, handler: { action in
                      self.navigationController?.popViewController(animated: true)
                  }))
                defaults.set(true, forKey: "15MinTriggered")
                defaults.synchronize()
                print("TRIGGERED 15 MINUTE ALERT")
        
                    // Present the controller
               self.present(alertController, animated: true, completion: nil)
  
    
    }
    
        func showCallAlertFour() {
            
            //If patient received wait 15 min alert, trigger this alert if BP still high
            if defaults.bool(forKey: "15MinTriggered") == true {
                let alertController = UIAlertController(title: "Vitals Recorded", message: "Warning: Your blood pressure may still be high. Please contact a Grady nurse.", preferredStyle: .alert)

                               let callAction = UIAlertAction(title: "Call Grady Nurse", style: UIAlertActionStyle.default) {
                                               UIAlertAction in
                                               NSLog("Call Pressed")
                                              guard let number = URL(string: "tel://4046160600") else { return }
                                              UIApplication.shared.open(number)
                                              self.navigationController?.popViewController(animated: true)
                                           }
                               alertController.addAction(callAction)
                               alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
                                
                                //UNCOMMENT FOR A REASONS WHY ALERT
                              //  self.reasonsWhyAlert()
                                self.navigationController?.popViewController(animated: true)
                                self.resetPicker()
                                
                                  }))
                
                //Set default back to false 
                                    defaults.set(false, forKey: "15MinTriggered")
                                    defaults.synchronize()
                                    // Present the controller
                               self.present(alertController, animated: true, completion: nil)
               
            } else {
                print("No need for alert four.")
            }
         
        }
    
//UNCOMMENT FOR A REASONS WHY SCREEN
    
//    func reasonsWhyAlert() {
//             let alertController = UIAlertController(title: "Why did you click Cancel?", message: "", preferredStyle: .alert)
//
//
//                   let mistakeAction = UIAlertAction(title: "I clicked cancel by mistake", style: UIAlertActionStyle.default) {
//                                   UIAlertAction in
//
//                    self.defaults.set(true, forKey: "15MinTriggered")
//                    self.defaults.synchronize()
//
//                        self.showCallAlertFour()
//                    }
//                   alertController.addAction(mistakeAction)
//                   alertController.addAction(UIAlertAction(title: "I don't feel like talking", style: UIAlertAction.Style.default, handler: { action in
//                       //Provide user with info on BP info collection.
//                       self.performSegue(withIdentifier: "showBPReasons", sender: self)
//                   }))
//
//
//                        // Present the controller
//                   self.present(alertController, animated: true, completion: nil)
//
//    }
    
    @IBAction func submitData(_ sender: UIButton) {
        //Send picture and text?
        
        defaults.set(true, forKey: "leftSubmitted")
        defaults.synchronize()
        submitButton.alpha = 0.5
      
        let selectedSysValue = systolicData[pressureValue.selectedRow(inComponent: 0)]
        let selectedDiaValue = diastolicData[pressureValue.selectedRow(inComponent: 1)]
        let selectedPulse = pulseData[pressureValue.selectedRow(inComponent: 2)]
        
//        guard selectedSysValue == 0 else {
//            emptySystolic()
//            return
//        }
//
//        guard selectedDiaValue == 0 else {
//            emptyDiastolic()
//            return
//        }
//
//        guard selectedPulse == 0 else {
//            emptyPulse()
//            return
//        }
//
        
        guard selectedDiaValue < selectedSysValue else {
            incorrectValues()
            return
        }
        
        
        guard let _ = chosenImage else {
            emptyValues(arm: "left")
            return
        }
    

        sendPressure(systolic: selectedSysValue, diastolic: selectedDiaValue, pulse: selectedPulse, arm: "left")


        
    }
    
    @IBAction func submitDataRight(_ sender: Any) {
        defaults.set(true, forKey: "rightSubmitted")
        defaults.synchronize()
        submitButtonRight.alpha = 0.5
            
         //Send picture and text?
                let selectedSysValue = systolicData[pressureValue.selectedRow(inComponent: 0)]
                let selectedDiaValue = diastolicData[pressureValue.selectedRow(inComponent: 1)]
                let selectedPulse = pulseData[pressureValue.selectedRow(inComponent: 2)]
                
        //        guard selectedSysValue == 0 else {
        //            emptySystolic()
        //            return
        //        }
        //
        //        guard selectedDiaValue == 0 else {
        //            emptyDiastolic()
        //            return
        //        }
        //
        //        guard selectedPulse == 0 else {
        //            emptyPulse()
        //            return
        //        }
        //
                
                guard selectedDiaValue < selectedSysValue else {
                    incorrectValues()
                    return
                }
                
                
                guard let _ = chosenImage else {
                    emptyValues(arm: "right")
                    return
                }
                
    
        sendPressure(systolic: selectedSysValue, diastolic: selectedDiaValue, pulse: selectedPulse, arm: "right")
        
         
    }
    
  
    func resetPicker() {
        print("RESET PICKER VIEW")
        pressureValue.selectRow(0, inComponent: 0, animated: false)
        pressureValue.selectRow(0, inComponent: 1, animated: false)
        pressureValue.selectRow(0, inComponent: 2, animated: false)
       
 
    }
    
    
    func emptySystolic() {
        self.showAlert(title: NSLocalizedString( "Empty Values", comment: ""),
                       message: NSLocalizedString("Systolic value cannot be blank.", comment:""))
    }
    
    func emptyPulse() {
           self.showAlert(title: NSLocalizedString( "Empty Values", comment: ""),
                          message: NSLocalizedString("Pulse value cannot be blank.", comment:""))
    }
    
    func emptyDiastolic() {
              self.showAlert(title: NSLocalizedString( "Empty Values", comment: ""),
                             message: NSLocalizedString("Diastolic value cannot be blank.", comment:""))
       }
    
    
    func incorrectValues() {
        self.showAlert(title: NSLocalizedString( "Incorrect Values", comment: ""),
                       message: NSLocalizedString("Systolic value must be larger than diastolic value.", comment:""))
    }
    
    //MARK: - Delegates
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        cameraView.contentMode = .scaleAspectFit
        cameraView.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return systolicData.count
        case 1:
            return diastolicData.count
        case 2:
            return pulseData.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if chosenImage != nil && validatePressure(){
//            submitButton.isEnabled = true
//        }
//        else {
//            submitButton.isEnabled = false
//        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            if (row == 0 || row > 270) {
                return "---"
            }
            return String(systolicData[row])
        case 1:
            if (row == 0 || row > 270) {
                return "---"
            }
            return String(diastolicData[row])
        case 2:
            if (row == 0 || row > 187) {
                return "---"
            }
            return String(pulseData[row])
        default:
            return "---"
        }
        
    }
    
    func sendPressureWithoutImage(systolic: Int, diastolic: Int, pulse: Int, arm: String){
       let (formattedDate, millis) = formattedDateAndMillis()
        let (weeklyMilis) = formattedWeeklyMillis()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let reportedVitalsEntity = NSEntityDescription.entity(forEntityName: "ReportedVitals", in: managedContext)!
        let reportedVitals = NSManagedObject(entity: reportedVitalsEntity, insertInto: managedContext)
        
        let imageName = "empty.jpeg"
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d y"
        
        
        
        // send presure
        if let user = DataHolder.userID {
            let fileName = "vitals"
            let values = "systolic: \(systolic), diastolic: \(diastolic), pulse: \(pulse)"
            reportedVitals.setValue(today, forKeyPath: "reportedDate")
            reportedVitals.setValue(values, forKeyPath: "vitals")
            reportedVitals.setValue(arm, forKeyPath: "arm")
            
             
             do {
                try managedContext.save()
                print("Data saved")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            // send data
            print(fileName)
            let string = "participant_id,systolic_pressure,diastolic_pressure,pulse\n" +
            "\(user),\(systolic),\(diastolic),\(pulse)"
            print(string)
            let data = string.data(using: .utf8)!
            self.sendToBackend(image: UIImage(named:imageName)!, formattedDate: formattedDate, millis: millis, systolic: systolic, diastolic: diastolic, pulse: pulse, arm: arm )
        }
    }
    
    func sendPressure(systolic: Int, diastolic: Int, pulse: Int, arm:String){
        
        let (formattedDate, millis) = formattedDateAndMillis()
        let (weeklyMilis) = formattedWeeklyMillis()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let reportedVitalsEntity = NSEntityDescription.entity(forEntityName: "ReportedVitals", in: managedContext)!
        let reportedVitals = NSManagedObject(entity: reportedVitalsEntity, insertInto: managedContext)
        
        
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d y"
        
        
        
        // send presure
        if let user = DataHolder.userID {
            let fileName = "vitals"
            let values = "systolic: \(systolic), diastolic: \(systolic), pulse: \(pulse)"
            let userArm = arm
            
            reportedVitals.setValue(today, forKeyPath: "reportedDate")
            reportedVitals.setValue(values, forKeyPath: "vitals")
            reportedVitals.setValue(userArm, forKeyPath: "arm")
             
             do {
                try managedContext.save()
                print("Data saved")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            // send data
            print(fileName)
            let string = "participant_id,systolic_pressure,diastolic_pressure,pulse\n" +
            "\(user),\(systolic),\(diastolic),\(pulse)"
            print(string)
            let data = string.data(using: .utf8)!
            
            
         let alert = UIAlertController(title: "Save Vitals", message: "Select which arm vitals were taken with", preferredStyle: UIAlertController.Style.alert)
            
        self.sendToBackend(image: self.chosenImage!, formattedDate: formattedDate, millis: millis, systolic: systolic, diastolic: diastolic, pulse: pulse, arm: arm)
           
    
            
     
        }
       
    }
    
    
    func sendToBackend(image: UIImage, formattedDate: String, millis: Int64, systolic: Int, diastolic: Int, pulse: Int, arm: String){
        if let user = DataHolder.userID, let data = UIImageJPEGRepresentation(image, 0.65) {
                   let fileName = "\(user)_\(millis)_bp.jpg"
                   // send image
            
            KRProgressHUD.show(withMessage:NSLocalizedString("Saving vitals..", comment: ""), completion: nil)
            API.default.uploadVitals(millis: formattedWeeklyMillis(), data: data, fileName: fileName, spb: systolic, dbp: diastolic, pulse: pulse, created_at: millis, completion: { (result) in
            
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
                            
                            
                            if systolic > 160 ||  diastolic > 110 {
                                if self.defaults.bool(forKey: "15MinTriggered") == true {
                                    self.showCallAlertFour()
                                   
                                  
                                } else {
                                    self.showCallAlertThree()
                                   
                                    
                                  
                                }
                            }
                            
                            if (140 ... 160).contains(systolic) {
                                self.showCallAlert()
                              
                               
                            }
                            if (90 ... 110).contains(diastolic) {
                                self.showCallAlert()
                              
                               
                            }
                            if systolic < 100 ||  diastolic < 70 {
                                self.showCallAlertTwo()
                             
                              
                            
                            } else {
                                
                                let alert = UIAlertController(title: NSLocalizedString("Vitals Recorded Successfully", comment: ""),
                                                                  message:"Please upload again after 12 hours.",
                                                                  preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                        self.navigationController?.popViewController(animated: true)
                                    }))
                                    
                                    self.present(alert, animated: true, completion: nil)
                                    if systolic > 140 ||  diastolic > 100 {
                                         print("Too high")
                                }
                               
                            }
                        
                       }
                   })
        }
      
      resetPicker()
      cameraView.image = UIImage(named: "monitor")
  
      
    }
    
    func sendImage(image: UIImage, formattedDate: String, millis: Int64) {
        if let user = DataHolder.userID, let data = UIImageJPEGRepresentation(image, 0.65) {
            let fileName = "bloodpressure.jpg"
            // send image
            KRProgressHUD.show(withMessage:NSLocalizedString("Sending image..", comment: ""), completion: nil)
            API.default.uploadFile(millis: millis, data: data, fileName:fileName, completion: { (result) in
                KRProgressHUD.dismiss()
                print("result data sending: \(result)")
                switch result {
                case let .Error(message):
                    self.showError(message: message)
                case .Success:
                    AppDelegate.appDelegate?.scheduleBloodNotification()
                    let alert = UIAlertController(title: NSLocalizedString("Vitals Recorded Successfully", comment: ""),
                                                  message:"Please upload again after 12 hours.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
        else {
            KRProgressHUD.dismiss()
        }
        
      
        
    }
    
        func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
            dismiss(animated: true, completion: nil)
            
            if reason == .completed {
                keys.forEach({ key in
                    self.resultsArray[key] = gatherDepressionData(stepIdentifier: key, viewControllerToPresent: taskViewController)
                })
                var firstLine = String()
                var secondLine = String()
                resultsArray.forEach { key, value in
                    firstLine.append(key)
                    firstLine.append(",")
                    secondLine.append("\(value)")
                    secondLine.append(",")
                }
                firstLine =  firstLine.trimmingCharacters(in: CharacterSet.init(charactersIn: ","))
                secondLine = secondLine.trimmingCharacters(in: CharacterSet.init(charactersIn: ","))
                let resultFile = firstLine + "\n" + secondLine
                sendFile(fileName: "symptoms", withString: resultFile) { success in
                    if success {
    //                    self.calculateScore()
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
        
//        @IBAction func reportSymptoms(_ sender: UIButton) {
//            let taskViewController = ORKTaskViewController(task: SymptomTask, taskRun: nil)
//            taskViewController.modalPresentationStyle = UIModalPresentationStyle(rawValue: 0)!
//            taskViewController.navigationBar.prefersLargeTitles = false
//            //UIView.appearance().backgroundColor = UIColor.lightGray
//            taskViewController.delegate = self
//            self.present(taskViewController, animated: true, completion: nil)
//        }
        
}
