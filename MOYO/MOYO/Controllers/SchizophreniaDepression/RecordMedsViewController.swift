//
//  RecordMedsViewController.swift
//  MOYO
//
//  Created by Whitney Bremer on 3/30/21.
//  Copyright © 2021 Clifford Lab. All rights reserved.
//

import UIKit
import iOSDropDown

class RecordMedsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var value = String()
    var last = -1
    var pickerData: [String] = [String]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        for _ in 0...medFrequency.count - 1 {
            if (pickerView.tag == 1) {
                return pickerData.count
            } else if (pickerView.tag == 2) {
                return pickerData.count
            } else if (pickerView.tag == 3) {
                return pickerData.count
            } else if (pickerView.tag == 4) {
                return pickerData.count
            }
        }
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag==1){
            //return pickerData[row]
            return NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]).string
        } else if (pickerView.tag==2) {
          
            return NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]).string
        } else if (pickerView.tag==3) {
     
            return NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]).string
        } else {
            return NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]).string
        }
    }
    
    @IBOutlet var medicationOutlet: [DropDown]!
    
    
    
    @IBOutlet var medFrequency: [UIPickerView]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
      self.navigationItem.title = "HOW OFTEN DO YOU FORGET?"

        for i in 0...medFrequency.count - 1 {
            medFrequency[i].delegate = self
            medFrequency[i].dataSource = self
            medFrequency[i].reloadAllComponents()
            pickerData = ["No Answer", "Forgot Today", "Less Than Half The Time", "More Than Half The Time", "Always Forget"]
        }

        for i in 0...medicationOutlet.count - 1 {
            medicationOutlet[i].addTarget(self, action: #selector(RecordMedsViewController.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
            
            medicationOutlet[i].didSelect{(selectedText , index ,id) in
                print(selectedText)
              
            }
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        value = textField.text!
        getData { (true) in
              
            }
    }
    
    
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }
    
    @IBAction func submitMeds(_ sender: UIButton) {
        
        var firstLine = String()
        var secondLine = String()
        
        var patientInfo = ""
        
        for i in 0...medicationOutlet.count - 1 {
            print(medicationOutlet!)
            if medicationOutlet[i].text != "" {
                patientInfo.append("Medication: \(medicationOutlet[i].text ?? "None Entered")")
                firstLine.append(medicationOutlet[i].text ?? "None Entered")
                firstLine.append(",")
                
            } else {
                patientInfo.append("Medication: None Entered")
                firstLine.append("None Entered")
                firstLine.append(",")
                            
            }
            
            
        }
        
        for i in 0...medFrequency.count - 1 {
            let selectedFrequency = pickerData[medFrequency[i].selectedRow(inComponent: 0)]
            patientInfo.append("Frequency: \(selectedFrequency)")
            secondLine.append(selectedFrequency)
                secondLine.append(",")
        }
              
             
        
        
        firstLine = firstLine.trimmingCharacters(in: CharacterSet.init(charactersIn: ","))
        secondLine = secondLine.trimmingCharacters(in: CharacterSet.init(charactersIn: ","))
        let resultFile = firstLine + "\n" + secondLine
        
        
        sendFile(fileName: "muqforgottenmeds.csv", withString: resultFile) { success in
            if success {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
  
    func getData(completionHandler: @escaping ((Bool)) -> ()) {
        guard let url = URL(string: "https://rxnav.nlm.nih.gov/REST/spellingsuggestions.json?name=\(value)") else {
            print("Url conversion issue.")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            // Check if data was received successfully
            if error == nil && data != nil {
                do {
                
                    // Convert NSData to Dictionary where keys are of type String, and values are of any type
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]

                    if let suggestionGroup = json["suggestionGroup"] as? [String:AnyObject] {
                
                        if let suggestionList = suggestionGroup["suggestionList"] as? [String:AnyObject] {
                    
                            if let suggestion = suggestionList["suggestion"] as? [String] {
                                for i in 0...self.medicationOutlet.count - 1 {

                                    DispatchQueue.main.async {
                                        if self.medicationOutlet[i].isEditing {
                                            self.medicationOutlet[i].hideList()
                                            self.last = i
                                            self.medicationOutlet[i].optionArray = suggestion
                                            self.medicationOutlet[i].showList()
                                        }
                                    }

                                }
                                
                            }
                        }
                    }
                    
                    completionHandler(true)

                } catch {
                    completionHandler(false)
                }
            }
            else if error != nil
            {
                completionHandler(false)
            }
        }).resume()
    }
    
}
