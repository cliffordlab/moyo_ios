//
//  SignInViewController.swift
//  MOYO
//
//  Created by Corey S on 8/23/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit
import KRProgressHUD


class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var signinButton: LegalCommonButton!
    
    var fbProfile: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    
    @IBAction func signInBtn_Click(_ sender: Any) {
        
        errorLabel.text = ""
        view.endEditing(true)
        var participantID: Int!
        var participantEmail: String!
        
        
        guard let userInput = emailText.text, userInput.count > 0 else {
            errorLabel.text = NSLocalizedString("Please input valid participation email or id.", comment: "")
            return
        }
        
        guard let password = passwordText.text, password.count >= 3 else {
            errorLabel.text = NSLocalizedString("Please input password.", comment: "")
            return
        }
    
        
        if let convertedNumber = Int(userInput) {
            participantID = convertedNumber
            participantEmail = ""
        }
        else {
            participantEmail = userInput
            participantID = 0
        }
        
        KRProgressHUD.show(withMessage:  NSLocalizedString("Authorizing", comment: ""), completion: nil)
        API.default.login(user: participantEmail, password: password, participantID: participantID) { (result) in
            KRProgressHUD.dismiss()
            switch result {
            case let .Error(message):
                self.showError(message: message)
            case .Success:
                AppDelegate.appDelegate?.scheduleBloodNotification()
                AppDelegate.appDelegate?.scheduleFoodNotification()
                let appDelegateTemp = UIApplication.shared.delegate as? AppDelegate
                appDelegateTemp?.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
      
            }
        }


    }
    
    @IBAction func contactUs(_ sender: Any) {
        self.performSegue(withIdentifier: "showConsent", sender: nil)
    }

}

