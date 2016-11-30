//
//  DetailLabelTableViewCell.swift
//  DayReco
//
//  Created by Victor Wei on 10/6/16.
//  Copyright © 2016 VictorW. All rights reserved.
//

import UIKit

class DetailLabelTableViewCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var iconImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
