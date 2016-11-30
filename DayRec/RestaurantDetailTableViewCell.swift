//
//  RestaurantDetailTableViewCell.swift
//  DayReco
//
//  Created by Victor Wei on 10/4/16.
//  Copyright © 2016 VictorW. All rights reserved.
//

import UIKit

class RestaurantDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var priceRatingLabel: UILabel!
    
    
    @IBOutlet weak var rating1Img: UIImageView!
    @IBOutlet weak var rating2Img: UIImageView!
    @IBOutlet weak var rating3Img: UIImageView!
    @IBOutlet weak var rating4Img: UIImageView!
    @IBOutlet weak var rating5Img: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    var baseRating = 0
    var ratingRemainder: Float = 0.0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setImages() {
        switch baseRating {
        case 1:
            rating1Img.image = UIImage(named: "full-star")
            if ratingRemainder > 0.25 && ratingRemainder < 0.75{
                rating2Img.image = UIImage(named: "half-star")
            } else if ratingRemainder >= 0.75 {
                rating2Img.image = UIImage(named: "full-star")
            }
            
        case 2:
            rating1Img.image = UIImage(named: "full-star")
            rating2Img.image = UIImage(named: "full-star")
            if ratingRemainder > 0.25 && ratingRemainder < 0.75{
                rating3Img.image = UIImage(named: "half-star")
            } else if ratingRemainder >= 0.75 {
                rating3Img.image = UIImage(named: "full-star")
            }
            
        case 3:
            rating1Img.image = UIImage(named: "full-star")
            rating2Img.image = UIImage(named: "full-star")
            rating3Img.image = UIImage(named: "full-star")
            if ratingRemainder > 0.25 && ratingRemainder < 0.75{
                rating4Img.image = UIImage(named: "half-star")
            } else if ratingRemainder >= 0.75 {
                rating4Img.image = UIImage(named: "full-star")
            }
            
        case 4:
            rating1Img.image = UIImage(named: "full-star")
            rating2Img.image = UIImage(named: "full-star")
            rating3Img.image = UIImage(named: "full-star")
            rating4Img.image = UIImage(named: "full-star")
            if ratingRemainder > 0.25 && ratingRemainder < 0.75{
                rating5Img.image = UIImage(named: "half-star")
            } else if ratingRemainder >= 0.75 {
                rating5Img.image = UIImage(named: "full-star")
            }
            
        case 5:
            rating1Img.image = UIImage(named: "full-star")
            rating2Img.image = UIImage(named: "full-star")
            rating3Img.image = UIImage(named: "full-star")
            rating4Img.image = UIImage(named: "full-star")
            rating5Img.image = UIImage(named: "full-star")
            
        default:
            break
        }
        
        

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
