//
//  ImageTableViewCell.swift
//  DayReco
//
//  Created by Victor Wei on 10/5/16.
//  Copyright © 2016 VictorW. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {


    @IBOutlet weak var imgView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
