//
//  WTViewController.swift
//  MOYO
//
//  Created by Corey Shaw on 9/22/20.
//  Copyright © 2020 Clifford Lab. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController,  WTViewControllerDelegate{
  let walkthroughs = [
    WTModel(title: "Step 1", subtitle: "Sit on a chair with your feet flat on the floor. Rest the arm you are going to use on a table or big pillow so that the cuff is at the same level as your heart.", icon: ""),
    WTModel(title: "Step 2", subtitle: "Make sure the air plug is securely inserted in the main unit.", icon: ""),
    WTModel(title: "Step 3", subtitle: "Turn the palm of your hand upward.", icon: ""),
    WTModel(title: "Step 4", subtitle: "Apply the cuff to your left upper arm so the blue stripe is on the inside of your arm and aligned with your middle finger. The air tube runs down the inside of your arm. The bottom of the cuff should be approximately 1/2&quot; above your elbow.", icon: ""),
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    let walkthroughVC = self.walkthroughVC()
    walkthroughVC.delegate = self
    self.addChildViewControllerWithView(walkthroughVC)
  }
  
  func walkthroughViewControllerDidFinishFlow(_ vc: WTViewController) {
    UIView.transition(with: self.view, duration: 1, options: .transitionFlipFromLeft, animations: {
     self.navigationController?.popViewController(animated: true)
    }, completion: nil)
  }
  
  fileprivate func walkthroughVC() -> WTViewController {
    let viewControllers = walkthroughs.map { ClassicWTViewController(model: $0, nibName: "ClassicWTViewController", bundle: nil) }
    return WTViewController(nibName: "WTViewController",
                                        bundle: nil,
                                        viewControllers: viewControllers)
  }
}

