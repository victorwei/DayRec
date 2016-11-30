//
//  SignUpViewController.swift
//  DayRec
//
//  Created by Victor Wei on 10/8/16.
//  Copyright © 2016 victorW. All rights reserved.
//

import UIKit


class SignUpViewController: UIViewController, UITextViewDelegate {

    //MARK: - Properties
    @IBOutlet weak var fNameTextField: UITextField!
    @IBOutlet weak var lNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    
    var database = sqlDB()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the textview delegate
        bioTextView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
//        return UIStatusBarStyle.LightContent
//    }
    
    //clicking on the back button goes back to login page
    @IBAction func goBackToLoginAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //determine if fields are filledout
    func allFieldsFilled () -> Bool {
        if fNameTextField.text == "" || lNameTextField.text == "" || emailTextField.text == "" || passwordTextField == "" {
            return false
        }
        return true
    }
    
    // textView delegate methods to create a placeholder effect for the textView
    func textViewDidEndEditing(textView: UITextView) {
        if bioTextView.text == "" {
            bioTextView.textColor = UIColor.lightGrayColor()
            bioTextView.text = "Bio (200 characters or less)"
        }
    }
    
    //When the textView becomes first responder, remove the placeholder text and set the font color to black.
    func textViewDidBeginEditing(textView: UITextView) {
        bioTextView.text = ""
        bioTextView.textColor = UIColor.blackColor()
    }
    
    
    //IBAction to register the user with the filled out fields
    @IBAction func registerAction(sender: AnyObject) {
        if allFieldsFilled() {
            
            //Determine if user already exists in the database
            if database.doesUserExist(emailTextField.text) {
                //alert user that person with the same email is already in use
                displayAlert()
            } else {
                //add the user to the database
                database.addUser(fNameTextField.text, lName: lNameTextField.text, email: emailTextField.text, shortBio: bioTextView.text, password: passwordTextField.text, picture: "")
                performSegueWithIdentifier("unwindToLoginSegue", sender: self)
            }
            
        }
        
        
    }
    
    
    
    //Display an alert message to the user.
    func displayAlert () {
        //Create UIAlertController with the title and message
        let alertController = UIAlertController(title: "Error", message: "Email already registered!", preferredStyle: .Alert)
        //Define the button action and add it to the alert controller
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(okAction)
        //Show the alert
        presentViewController(alertController, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
