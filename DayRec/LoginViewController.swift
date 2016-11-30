//
//  LoginViewController.swift
//  DayReco
//
//  Created by iOS on 9/29/16.
//  Copyright © 2016 VictorW. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit




class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    //for testing purposes
    @IBOutlet weak var fname: UILabel!
    
    //MARK: - Properties
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginWithFbBtn: FBSDKLoginButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var database: sqlDB!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDatabase()
        configureFacebook()
        
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string:"username",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"password",
                                                               attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Setup the database objects.  Create the databases that will be used for the entire app
    func setupDatabase() {
        database = sqlDB()
        database.createUserDB()
        database.createRecoDB()
        database.createLocationsDB()
        database.createRestaurantsDB()
        database.createRatingsDB()
    }
    
    //MARK: - IBActions
    
    //Handles case where user clicks on the login button
    @IBAction func loginAction(sender: UIButton) {
        //check condition if user login is valid
        if (database.isUserValid(usernameTextField.text, password: passwordTextField.text)){
            //login and go to the next view controller.
            login(usernameTextField.text!)
        } else {
            //display alert message saying login is not valid
            displayAlert()
            
        }
    }
    
    //Create the User object and set it the User object from results from the SQL database.  Present the next view controller of the app.
    func login(email: String) {
        
        // get the user data from the database based on email and create set the user's variables to that of the database's
        let userValues = self.database.getUserData(email)
        User.sharedInstance.userId = userValues[0] as! Int
        User.sharedInstance.fName = userValues[1] as! String
        User.sharedInstance.lName = userValues[2] as! String
        User.sharedInstance.bio = userValues[3] as! String
        User.sharedInstance.picture = userValues[4] as! String
        User.sharedInstance.email = email
        
        //get an instance of the tabbarController and present it
        var tabViewController = UITabBarController()
        tabViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("tabBarViewController") as! UITabBarController
        presentViewController(tabViewController, animated: true, completion: nil)
    }
    
    
    
    
    //
    @IBAction func signUpAction(sender: AnyObject) {
        
    }
    
    
    
    
    
    
    /***
     
    Facebook Delegate and Methods
 
    ***/
    
    func configureFacebook() {
        loginWithFbBtn.readPermissions = ["public_profile", "email", "user_friends"];
        loginWithFbBtn.delegate = self
    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        //request facebook information
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, picture.type(large), email"]).startWithCompletionHandler { (connection, result, error) -> Void in
            
            //get the data for the facebook user
            let strFirstName: String = (result.objectForKey("first_name") as? String)!
            let strLastName: String = (result.objectForKey("last_name") as? String)!
            let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
            let stremail: String = (result.objectForKey("email") as? String)!
            
            //if the user doesn't exist in current database, add the user
            if !self.database.doesUserExist(stremail){
                self.database.addUser(strFirstName, lName: strLastName, email: stremail, shortBio: "", password: "", picture: strPictureURL)
            }
            //login to the next view controller
            self.login( stremail)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    
    
    //Unwind Segue for SignUpViewController
    @IBAction func performUnwindSegue(segue: UIStoryboardSegue){
        if segue.identifier == "unwindToLoginSegue" {
        }
        
    }
    
    
    
    
    
    
    /***
     
     Alert and Error Handling
     
     ***/
    
    
    //Display an alert if the username or password doesn't match anything in the database
    func displayAlert () {
        //Create UIAlertController with the title and message
        let alertController = UIAlertController(title: "Error", message: "Invalid username password!", preferredStyle: .Alert)
        //Define the button action and add it to the alert controller
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(okAction)
        //Show the alert
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}


