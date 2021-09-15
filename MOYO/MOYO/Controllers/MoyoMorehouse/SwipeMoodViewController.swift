//
//  SwipeMoodViewController.swift
//  MOYO
//
//  Created by Whitney H on 9/5/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit
import CoreData

class SwipeMoodViewController: UIViewController {
    
    let moodImages : [String] = ["icons8-angry-filled.png", "icons8-sad-filled.png", "icons8-neutral-filled.png", "icons8-happy-filled.png", "icons8-lol-filled.png"]
    var imageIndex = 0
    var userMood = String()
    
    @IBOutlet weak var moodImageView: UIImageView!
    override func viewDidLoad() {
        
        //Setting initial image.
        moodImageView.image = UIImage(named: "icons8-neutral-filled.png")
        super.viewDidLoad()
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        self.view.addGestureRecognizer(swipeUp)
        
    }
    func changeMoodOptions() {
        if imageIndex == moodImages.count - 1 {
            imageIndex = 0
        } else {
            imageIndex += 1
        }
        moodImageView.image = UIImage(named: moodImages[imageIndex])
    }
    
    func recordMood(){
        guard (UIApplication.shared.delegate as? AppDelegate) != nil else { return }
        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let swipeSurveyEntity = NSEntityDescription.entity(forEntityName: "SwipeSurvey", in: managedContext)!
//        let swipeSurvey = NSManagedObject(entity: swipeSurveyEntity, insertInto: managedContext)
//
        if imageIndex == 0 {
            userMood = "Angry"
        } else if imageIndex == 1 {
            userMood = "Sad"
        } else if imageIndex == 2 {
            userMood = "Neutral"
        } else if imageIndex == 3 {
            userMood = "Happy"
        } else if imageIndex == 4 {
            userMood = "Very Happy"
        }
        let sum = imageIndex + 1;
        print(sum)
        let data = "userMood\n\(userMood)"
        
     //   swipeSurvey.setValue(sum, forKeyPath: "score")
//        
//        do {
//            try managedContext.save()
//            print("Data saved")
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
        
        sendFile(fileName: "ms.csv", withString: data) { success in
            if success {
                let alert = UIAlertController(title: NSLocalizedString("Data Submitted Successfully", comment: ""),
                                              message:"Please upload again after 24 hours.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.navigationController?.popViewController(animated: true)
                }))
               self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.down:
                changeMoodOptions()
            case UISwipeGestureRecognizer.Direction.up:
                changeMoodOptions()
            default:
                break
            }
        }
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        //Pass userMood into your send to AWS function.
        recordMood()
        print(userMood)
    }
    
}
