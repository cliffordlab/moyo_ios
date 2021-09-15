//
//  SymptomsHistoryTableViewCell.swift
//  MOYO
//
//  Created by Whitney Bremer on 6/14/21.
//  Copyright © 2021 Clifford Lab. All rights reserved.
//

import UIKit

class SymptomsHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationTitleLabel: UILabel!
    @IBOutlet weak var notificationDateLabel: UILabel!
    @IBOutlet weak var notificationContentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }


}
