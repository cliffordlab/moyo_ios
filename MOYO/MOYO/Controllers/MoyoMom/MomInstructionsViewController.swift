//
//  MomInstructionsViewController.swift
//  MOYO
//
//  Created by Whitney Bremer on 7/15/21.
//  Copyright © 2021 Clifford Lab. All rights reserved.
//

import UIKit

class MomInstructionsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let contentWidth = scrollView.bounds.width
        let contentHeight = scrollView.bounds.height * 1.6
             scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)

           
           
    }

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentView: UIView!
    

}
