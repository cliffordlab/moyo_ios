//
//  WalkthroughViewController.swift
//  MOYO
//
//  Created by Corey Shaw on 2/27/20.
//  Copyright © 2020 Clifford Lab. All rights reserved.
//

import UIKit

class InstructionContentViewController: UIViewController {

    @IBOutlet var headingLabel: UILabel!
        @IBOutlet var contentLabel: UILabel!
        @IBOutlet var contentImageView: UIImageView!
        @IBOutlet var pageControl: UIPageControl!
        @IBOutlet var forwardButton: UIButton!
        
        var index = 0
        var heading = ""
        var imageFile = ""
        var content = ""
        
        override func viewDidLoad() {
            super.viewDidLoad()

            headingLabel.text = heading
            contentLabel.text = content
            contentImageView.image = UIImage(named: imageFile)
            pageControl.currentPage = index
            
            switch index {
            case 0...1: forwardButton.setTitle("NEXT", for: .normal)
            case 2: forwardButton.setTitle("DONE", for: .normal)
            default: break
            }
            
        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        

        // MARK: - IBAction Methods
        
        @IBAction func nextButtonTapped(sender: UIButton) {
            
            switch index {
            case 0...1: // Next Button
                let pageViewController = parent as! InstructionPageViewController
                pageViewController.forward(index: index)
                
            case 2: // Done Button
                UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
                
                // Add Quick Actions
                if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
                    if let bundleIdentifier = Bundle.main.bundleIdentifier {
                        let shortcutItem1 = UIApplicationShortcutItem(type: "\(bundleIdentifier).OpenFavorites", localizedTitle: "Show Favorites", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "favorite-shortcut"), userInfo: nil)
                        let shortcutItem2 = UIApplicationShortcutItem(type: "\(bundleIdentifier).OpenDiscover", localizedTitle: "Discover Restaurants", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "discover-shortcut"), userInfo: nil)
                        UIApplication.shared.shortcutItems = [shortcutItem1, shortcutItem2]
                    }
                }
                
                dismiss(animated: true, completion: nil)
                
            default: break
                
            }
        }
    }
