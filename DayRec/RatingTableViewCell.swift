//
//  RatingTableViewCell.swift
//  DayRec
//
//  Created by Victor Wei on 10/11/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit

protocol ratingChanged : NSObjectProtocol {
    func changeRating (rating: Int, changed: Bool)
}

class RatingTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var rating1Btn: UIButton!
    @IBOutlet weak var rating2Btn: UIButton!
    @IBOutlet weak var rating3Btn: UIButton!
    @IBOutlet weak var rating4Btn: UIButton!
    @IBOutlet weak var rating5Btn: UIButton!
    weak var ratingDelegate : ratingChanged!
    
    
    var currentRating = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    @IBAction func rate1Action(sender: AnyObject) {
        rating1Btn.setImage(UIImage(named: "fire"), forState: .Normal)
        rating2Btn.setImage(UIImage(named: "fire-empty"), forState: .Normal)
        rating3Btn.setImage(UIImage(named: "fire-empty"), forState: .Normal)
        rating4Btn.setImage(UIImage(named: "fire-empty"), forState: .Normal)
        rating5Btn.setImage(UIImage(named: "fire-empty"), forState: .Normal)
        currentRating = 1
        ratingDelegate.changeRating(1, changed: true)
    }
    
    
    @IBAction func rate2Action(sender: AnyObject) {
        rating1Btn.setImage(UIImage(named: "fire"), forState: .Normal)
        rating2Btn.setImage(UIImage(named: "fire"), forState: .Normal)
        rating3Btn.setImage(UIImage(named: "fire-empty"), forState: .Normal)
        rating4Btn.setImage(UIImage(named: "fire-empty"), forState: .Normal)
        rating5Btn.setImage(UIImage(named: "fire-empty"), forState: .Normal)
        currentRating = 2
        ratingDelegate.changeRating(2, changed: true)
    }
    
    @IBAction func rate3Action(sender: AnyObject) {
        rating1Btn.setImage(UIImage(named: "fire"), forState: .Normal)
        rating2Btn.setImage(UIImage(named: "fire"), forState: .Normal)
        rating3Btn.setImage(UIImage(named: "fire"), forState: .Normal)
        rating4Btn.setImage(UIImage(named: "fire-empty"), forState: .Normal)
        rating5Btn.setImage(UIImage(named: "fire-empty"), forState: .Normal)
        currentRating = 3
        ratingDelegate.changeRating(3, changed: true)
    }
    
    
    @IBAction func rate4Action(sender: AnyObject) {
        rating1Btn.setImage(UIImage(named: "fire"), forState: .Normal)
        rating2Btn.setImage(UIImage(named: "fire"), forState: .Normal)
        rating3Btn.setImage(UIImage(named: "fire"), forState: .Normal)
        rating4Btn.setImage(UIImage(named: "fire"), forState: .Normal)
        rating5Btn.setImage(UIImage(named: "fire-empty"), forState: .Normal)
        currentRating = 4
        ratingDelegate.changeRating(4, changed: true)
    }
    
    
    @IBAction func rate5Action(sender: AnyObject) {
        
        rating1Btn.setImage(UIImage(named: "fire"), forState: .Normal)
        rating2Btn.setImage(UIImage(named: "fire"), forState: .Normal)
        rating3Btn.setImage(UIImage(named: "fire"), forState: .Normal)
        rating4Btn.setImage(UIImage(named: "fire"), forState: .Normal)
        rating5Btn.setImage(UIImage(named: "fire"), forState: .Normal)
        currentRating = 5
        ratingDelegate.changeRating(5, changed: true)
    }
    
    
    
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
