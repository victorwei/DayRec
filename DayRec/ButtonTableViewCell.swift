//
//  ButtonTableViewCell.swift
//  DayReco
//
//  Created by Victor Wei on 10/1/16.
//  Copyright © 2016 VictorW. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var buttonLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
