//
//  FoodDiaryViewController.swift
//  MOYO
//
//  Created by Corey S on 9/15/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit
import KRProgressHUD

class FoodDiaryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    internal let defaultOffset: CGFloat = 75
    internal let keyboardOffset: CGFloat = 160
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var fieldOffset: NSLayoutConstraint!
    var chosenImage: UIImage? = nil {
        didSet {
           // enableButton()
            cameraView.image = chosenImage
        }
    }
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var enterFood: UITextField!
    let picker = UIImagePickerController()
    var observers = [Any]()
    func enableButton() {
            submitButton.isEnabled = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        enterFood.delegate = self
        enterFood.autocorrectionType = .no
        cameraView.contentMode = .scaleAspectFit
        enableButton()
        let observer1 = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { (note) in
            self.fieldOffset.constant = self.keyboardOffset
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutSubviews()
            })
        }
        let observer2 = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { (note) in
            self.fieldOffset.constant = self.defaultOffset
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutSubviews()
            })
        }
        observers = [observer1,observer2]
        title = NSLocalizedString("Food", comment: "")
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapActon))
        self.view.addGestureRecognizer(tap)
    }
    deinit {
        observers.forEach{NotificationCenter.default.removeObserver($0)}
    }
    @objc func tapActon() {
        self.view.endEditing(true)
    }
    
    @IBAction func photoFromLibrary(_ sender: UIButton) {
        self.view.endEditing(true)
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func shootPhoto(_ sender: UIButton) {
        self.view.endEditing(true)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: false, completion: nil)
            
        } else {
            noCamera()
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
    
    func emptyValues() {
        let alert = UIAlertController(title: "Missing fields!", message: "Please take a picture of your food and enter a text description.", preferredStyle: UIAlertController.Style.alert)
        
        
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: { action in
            //Take user back to main page here & send recoreded info, if any.
           self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "WHY?", style: UIAlertAction.Style.default, handler: { action in
            //Provide user with info on Food info collection.
            self.foodAlert()
            
        }))
        
        //Dimisses popup so user can enter food.
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func foodAlert() {
        //For Food
        let alert = UIAlertController(title: "Why are we collecting this info?", message: "We are making an app to guess what you are eating. By taking a photo and writing down what you eat, it helps us build that app.", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "STILL NO", style: UIAlertAction.Style.default, handler: { action in
            //Take user back to main page here & send any recorded info.
            self.navigationController?.popViewController(animated: true)
        }))
        
        //Take user back to Food page to enter their info.
        alert.addAction(UIAlertAction(title: "OK, I'M IN!", style: UIAlertAction.Style.default, handler: nil))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func submitData(_ sender: UIButton) {
        if currentReachabilityStatus != .notReachable {
            print("Internet is connected")
        //Send picture and text?
            
        if enterFood.text!.isEmpty && chosenImage != nil {
            emptyValues()
            return
        }
            
        guard let text = enterFood.text else {
            emptyValues()
            return
        }
        guard let _ = self.chosenImage else {
            emptyValues()
            return
        }
        self.sendFood(food: text)
        } else {
            //Function to save locally for next time.
       print("No internet connection. Saving locally")
            if let image = chosenImage {
                if let data = image.jpegData(compressionQuality: 0.8) {
                    let filename = getDocumentsDirectory().appendingPathComponent("offlineFoodImage.png")
                    print(filename)
                    try? data.write(to: filename)
                }
            }
        }
        
    }
    
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    //MARK: - Delegates
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage //2
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enterFood.resignFirstResponder()
        return true
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
}



extension FoodDiaryViewController {
    func sendFood(food: String){
        let (formattedDate, millis) = formattedDateAndMillis()
        let (weeklyMilis) = formattedWeeklyMillis()
        // send presure
        if let user = DataHolder.userID {
            let fileName = "\(String(describing: DataHolder.userID!))_\(millis)_iOS_food.csv"
            // send data
            let string = "participant_id,foodname\n" +
            "\(user),\(food)"
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
            let fileName = "\(String(describing: DataHolder.userID!))_\(millis)_iOS_food.jpg"
            // send image
            KRProgressHUD.show(withMessage:NSLocalizedString("Sending image..", comment: ""), completion: nil)
            API.default.uploadFile(millis: weeklyMilis, data: data, fileName:fileName, completion: { (result) in
                KRProgressHUD.dismiss()
                print("result data sending: \(result)")
                switch result {
                case let .Error(message):
                    self.showError(message: message)
                case .Success:
                    AppDelegate.appDelegate?.scheduleFoodNotification()
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
