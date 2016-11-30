//
//  WriteRecoViewController.swift
//  DayReco
//
//  Created by Victor Wei on 10/1/16.
//  Copyright © 2016 VictorW. All rights reserved.
//

import UIKit

class WriteRecoViewController: UIViewController, UITextViewDelegate {

    
    
    @IBOutlet weak var postBtn: UIBarButtonItem!
    @IBOutlet weak var recoTextView: UITextView!
    
    
    var recoText = ""
    var placeHolderText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeHolderText = "Example:  As someone born in San Francisco, this my usual Saturday routine.  First I like to hit up Barracuda and grab brunch there.  For $9, you can drink as many mimosas as you can possibly handle in a hour and 30 minute window.  Afterwards, when I'm feeling nice and tipsy, I'll head over to Dolores Park where I'll bring some park supplies and chill with my group friends.  Dolores Park has a great view of the entire city and the park is usually filled with fun and unique individuals.  Make sure to look out for the guy selling rum filled coconuts!  He will open a coconut in front of you and pour in Captain Morgan into the coconut.  Best of all, he has a heavy pour!  \n If I feel like shopping a bit,  I'll hop on BART and go to Union Square. For dinner, I like to go grab ramen at Ramen Underground.  It can get pretty busy so be sure to allot 30 minutes before eating.  For night time activities, I'll head over to 1015 Folsom, which is a nightclub that will play trap heavy music.  1015 will bring some heavy hitting dj artists and the crowd is always lively and energetic.  This day is planned for individuals who love to eat and drink and party with friends"
        
        // Set up to make a fake placeholder text.  Set the textview's delegate to self.  Add the placeholder text, and set the text color to light gray
        //recoTextView.setContentOffset(CGPointZero, animated: false)
        recoTextView.scrollRangeToVisible(NSMakeRange(0, 0))
        
        recoTextView.delegate = self
        recoTextView.text = placeHolderText
        recoTextView.textColor = UIColor.lightGrayColor()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    @IBAction func addRecoAction(sender: UIBarButtonItem) {
        
        if recoTextView.text == placeHolderText || recoTextView.text == "" {
            //display error message
            displayAlert()
        } else {
            recoText = recoTextView.text
            performSegueWithIdentifier("unwindWriteRecoSegue", sender: self)
            
        }
        
       
    
    }
    
    // if user clicks on the textview, remove the placeholder text and set the text color to black.
    func textViewDidBeginEditing(textView: UITextView) {
        recoTextView.text = ""
        recoTextView.textColor = UIColor.blackColor()
    }
    

    
    
    func displayAlert () {
        //Create UIAlertController with the title and message
        let alertController = UIAlertController(title: "Field cannot be empty", message: "Please enter some text", preferredStyle: .Alert)
        //Define the button action and add it to the alert controller
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(okAction)
        //Show the alert
        presentViewController(alertController, animated: true, completion: nil)
    }
    

}
