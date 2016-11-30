//
//  CustomButton.swift
//  DayRec
//
//  Created by Victor Wei on 10/14/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit

/*******
 IBDesignable class used to give corner radius to certain UI elements
*******/


@IBDesignable class CustomButton: UIButton {
    
    //Set the corner radius of the button.  Gives the curved effect
    @IBInspectable var cornerRadius : CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0 }
    }
    
}



@IBDesignable class CustomTextView: UITextView {
    
    //Set the corner radius of the button.  Gives the curved effect
    @IBInspectable var cornerRadius : CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0 }
    }
    
}
