//
//  ReasonsWhyViewController.swift
//  MOYO
//
//  Created by Whitney Bremer on 8/3/21.
//  Copyright © 2021 Clifford Lab. All rights reserved.
//

import UIKit

class ReasonsWhyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func reasonOne(_ sender: UIButton) {
        
        sendFile(fileName: "symptomsreasonswhy.csv", withString: "I would rather talk to my own doctor.") { success in
            if success {
                
                self.navigationController?.backToViewController(viewController: HomePageViewController.self)
            }
        }
    }
    
    
    @IBAction func reasonTwo(_ sender: UIButton) {
        
        sendFile(fileName: "symptomsreasonswhy.csv", withString: "I am not concerned by these symptoms.") { success in
            if success {
            
                self.navigationController?.backToViewController(viewController: HomePageViewController.self)
            }
        }
    }
    
    @IBAction func reasonThree(_ sender: UIButton) {
        
        sendFile(fileName: "symptomsreasonswhy.csv", withString: "I do not like talking about my health on the phone.") { success in
            if success {
                
                self.navigationController?.backToViewController(viewController: HomePageViewController.self)
            }
        }
    }
    
    @IBAction func reasonFour(_ sender: UIButton) {

        sendFile(fileName: "symptomsreasonswhy.csv", withString:  "I did not find the Grady Nurse very useful last time.") { success in
            if success {
                
                self.navigationController?.backToViewController(viewController: HomePageViewController.self)
            }
        }
    }
    
    
}

//Extension to pop back to whatever VC you want in your stack 
extension UINavigationController {

    func backToViewController(viewController: Swift.AnyClass) {

            for element in viewControllers as Array {
                if element.isKind(of: viewController) {
                    self.popToViewController(element, animated: true)
                break
            }
        }
    }
}
