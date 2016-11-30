//
//  CityTableViewCell.swift
//  DayRec
//
//  Created by Victor Wei on 10/9/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    
    //MAFK: - Properties
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var recDescriptionLabel: UILabel!
    @IBOutlet weak var avgRatingLabel: UILabel!
    @IBOutlet weak var rating1Img: UIImageView!
    @IBOutlet weak var rating2Img: UIImageView!
    @IBOutlet weak var rating3Img: UIImageView!
    @IBOutlet weak var rating4Img: UIImageView!
    @IBOutlet weak var rating5Img: UIImageView!
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
