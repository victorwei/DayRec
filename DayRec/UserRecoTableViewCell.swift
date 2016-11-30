//
//  UserRecoTableViewCell.swift
//  DayRec
//
//  Created by Victor Wei on 10/10/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit

class UserRecoTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var recoLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
