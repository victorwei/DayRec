//
//  TextEditTableViewCell.swift
//  DayReco
//
//  Created by Victor Wei on 9/29/16.
//  Copyright © 2016 VictorW. All rights reserved.
//

import UIKit

class TextEditTableViewCell: UITableViewCell {

    @IBOutlet weak var defaultTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        defaultTextField.text = ""
//    }
}
