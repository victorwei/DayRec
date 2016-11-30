//
//  DescriptionTableViewCell.swift
//  DayRec
//
//  Created by Victor Wei on 10/13/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
