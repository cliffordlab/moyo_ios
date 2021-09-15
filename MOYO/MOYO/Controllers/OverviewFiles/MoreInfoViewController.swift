//
//  MoreInfoViewController.swift
//  MOYO
//
//  Created by Whitney Bremer on 6/1/21.
//  Copyright © 2021 Clifford Lab. All rights reserved.
//

import UIKit
import SwiftUI

class MoreInfoViewController: UIViewController {
    
    var depressionLink = "Click here for more information about the PHQ9 assessment"
    var anxietyLink = "Click here for more information about the GAD7 assessment."
    var moodLink = "Click here for more information about the Mood Survey"

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        infoLabel.addHyperLinksToText(originalText: "Click here for more information about the PHQ9 assessment", hyperLinks: ["Click here": "https://aims.uw.edu/resource-library/phq-9-depression-scale"])
        
        labelTwo.addHyperLinksToText(originalText: "Click here for more information about the GAD7 assessment", hyperLinks: ["Click here": "https://www.mirecc.va.gov/cih-visn2/Documents/Clinical/GAD_with_Info_Sheet.pdf"])
        
        labelThree.addHyperLinksToText(originalText: "Click here for more information about the Mood assessment", hyperLinks: ["Click here": "https://www.sciencedirect.com/science/article/pii/S0165032716307819"])

    }
    
    
    
    @IBOutlet weak var infoLabel: UITextView!
    
    @IBOutlet weak var labelTwo: UITextView!
    
    @IBOutlet weak var labelThree: UITextView!
    
    
}

extension UITextView {

  func addHyperLinksToText(originalText: String, hyperLinks: [String: String]) {
    let style = NSMutableParagraphStyle()
    style.alignment = .center
    let attributedOriginalText = NSMutableAttributedString(string: originalText)
    for (hyperLink, urlString) in hyperLinks {
        let linkRange = attributedOriginalText.mutableString.range(of: hyperLink)
        let fullRange = NSRange(location: 0, length: attributedOriginalText.length)
        attributedOriginalText.addAttribute(NSAttributedString.Key.link, value: urlString, range: linkRange)
        attributedOriginalText.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: fullRange)
        
       
    }

    self.linkTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.blue,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
    ]
    self.attributedText = attributedOriginalText
  }
}
