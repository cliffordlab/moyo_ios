//
//  BloodPressureViewController.swift
//  MOYO
//
//  Created by Corey S on 9/11/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit
import KRProgressHUD

class BloodPressureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var pressureValue: UIPickerView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    
    let picker = UIImagePickerController()
    let choicePicker = UIPickerView()
    //Content for picker views.
    let systolicData = [Int](29...300)
    let diastolicData = [Int](29...300)
    let pulseData = [Int](34...221)
    var chosenImage: UIImage? = nil {
        didSet {
            if chosenImage != nil{
                pressureValue.isUserInteractionEnabled = true
                pressureValue.alpha = 1
            }
        }
    }
    func enableButton() {
        submitButton.isEnabled = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Vitals", comment: "")
        picker.delegate = self
        enableButton()
        pressureValue.alpha = 0.5
        pressureValue.delegate = self
        pressureValue.selectRow(0, inComponent: 0, animated: false)
        pressureValue.selectRow(0, inComponent: 1, animated: false)
        pressureValue.selectRow(0, inComponent: 2, animated: false)
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
        let av = UIAlertController(title: NSLocalizedString("Take Photo", comment: ""),
                                   message: nil,
                                   preferredStyle: .actionSheet)
        let photo = UIAlertAction(title: NSLocalizedString("Camera", comment: ""),
                                  style: .default) { (act) in
                                    self.shootPhoto(UIButton())
        }
        let lib = UIAlertAction(title: NSLocalizedString("Photo from Gallery", comment: ""),
                                style: .default) { (act) in
                                    self.photoFromLibrary(UIButton())
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                   style: .cancel,
                                   handler: nil)
        av.addAction(photo)
        av.addAction(lib)
        av.addAction(cancel)
        self.present(av, animated: true, completion: nil)
    }
    func validatePressure() -> Bool{
        let selectedSysValue = systolicData[pressureValue.selectedRow(inComponent: 0)]
        let selectedDiaValue = diastolicData[pressureValue.selectedRow(inComponent: 1)]
        
        if selectedDiaValue >= selectedSysValue {
            return false
        }
        return true
    }
    
    func emptyValues() {
        //For BP
        let alert = UIAlertController(title: "Missing fields", message: "Please take a picture of your vitals and make sure you select your correct BP & HR from the picker menu.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: { action in
            //Take user back to main page here & sends recorded info, if any.
             self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "WHY?", style: UIAlertAction.Style.default, handler: { action in
            //Provide user with info on BP info collection.
            self.bpAlert()
            
        }))
        
        //Dimisses popup so user can enter vitals.
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func bpAlert() {
        //For BP
        let alert = UIAlertController(title: "Why are we collecting this info?", message: "We are making an app to automatically read your HR and BP from the photo. By taking a photo and selecting the right BP & HR, you will help us create this new app and save everyone time. ", preferredStyle: UIAlertController.Style.alert)
        
        
        alert.addAction(UIAlertAction(title: "STILL NO", style: UIAlertAction.Style.default, handler: { action in
            //Take user back to main page here & send any recorded info.
             self.navigationController?.popViewController(animated: true)
            
        }))
        
        //Take user back to BP page to enter their info.
        alert.addAction(UIAlertAction(title: "OK, I'M IN!", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func submitData(_ sender: UIButton) {
        //Send picture and text?
        let selectedSysValue = systolicData[pressureValue.selectedRow(inComponent: 0)]
        let selectedDiaValue = diastolicData[pressureValue.selectedRow(inComponent: 1)]
        
        
        
        guard selectedDiaValue < selectedSysValue else {
            incorrectValues()
            return
        }
        let selectedPulse = pulseData[pressureValue.selectedRow(inComponent: 2)]
        guard let _ = chosenImage else {
            emptyValues()
            return
        }
        sendPressure(systolic: selectedSysValue, diastolic: selectedDiaValue, pulse: selectedPulse)
    }
    
    
    func incorrectValues() {
        self.showAlert(title: NSLocalizedString( "Incorrect Values", comment: ""),
                       message: NSLocalizedString("Systolic value must be larger than diastolic value.", comment:""))
    }
    
    //MARK: - Delegates
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        self.chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
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
    func sendPressure(systolic: Int, diastolic: Int, pulse: Int){
        let (formattedDate, millis) = formattedDateAndMillis()
        let (weeklyMilis) = formattedWeeklyMillis()
        // send presure
        if let user = DataHolder.userID {
            let fileName = "\(String(describing: DataHolder.userID!))_\(millis)_iOS_bp.csv"
            // send data
            print(fileName)
            let string = "participant_id,systolic_pressure,diastolic_pressure,pulse\n" +
            "\(user),\(systolic),\(diastolic),\(pulse)"
            let data = string.data(using: .utf8)!
            KRProgressHUD.show(withMessage:NSLocalizedString("Sending data..", comment: ""), completion: nil)
            API.default.uploadFile(millis: weeklyMilis, data: data, fileName:fileName, completion: { (result) in
                switch result {
                case let .Error(message):
                    KRProgressHUD.dismiss()
                    self.showError(message: message)
                case .Success:
                    self.sendImage(image: self.chosenImage!, formattedDate: formattedDate, millis: millis)
                }
            })
        }
    }
    func sendImage(image: UIImage, formattedDate: String, millis: Int64) {
        let (weeklyMilis) = formattedWeeklyMillis()
        if let user = DataHolder.userID, let data = image.jpegData(compressionQuality: 0.65) {
            let fileName = "\(String(describing: DataHolder.userID!))_\(millis)_iOS_bp.jpg"
            // send image
            KRProgressHUD.show(withMessage:NSLocalizedString("Sending image..", comment: ""), completion: nil)
            API.default.uploadFile(millis: weeklyMilis, data: data, fileName:fileName, completion: { (result) in
                KRProgressHUD.dismiss()
                print("result data sending: \(result)")
                switch result {
                case let .Error(message):
                    self.showError(message: message)
                case .Success:
                    AppDelegate.appDelegate?.scheduleBloodNotification()
                    let alert = UIAlertController(title: NSLocalizedString("Data Submitted Successfully", comment: ""),
                                                  message:"Please upload again after 24 hours.",
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
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
