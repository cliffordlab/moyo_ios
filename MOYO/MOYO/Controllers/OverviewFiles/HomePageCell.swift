//
//  HomePageCell.swift
//  MOYO
//
//  Created by Corey S on 7/30/18.
//  Copyright © 2018 Clifford Lab. All rights reserved.
//

import UIKit

protocol HomePageCellDelegate {
    func didTapAboutButton(aboutAlert: String)
}

class HomePageCell: UITableViewCell {
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuTitle: UILabel!
    @IBOutlet weak var menuContent: UILabel!
    @IBOutlet weak var alertButton: UIButton!
    
    let alert = AboutAlert.self
    var delegate: HomePageCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
