//
//  ViewController.swift
//  tutorMe
//
//  Created by Peyt Spencer Dewar on 1/23/16.
//  Copyright © 2016 PSD. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import FBSDKLoginKit
import ParseFacebookUtilsV4
import FBSDKCoreKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var fbLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //customizeButton(fbLoginButton)
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            print("USER IS LOGGED IN")
            print(FBSDKAccessToken.currentAccessToken().userID)
            let liveFeedVC = self.storyboard?.instantiateViewControllerWithIdentifier("LiveFeedViewController") as! LiveFeedViewController
            
            let liveFeedPageNav = UINavigationController(rootViewController: liveFeedVC)
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController = liveFeedPageNav
        }
        else
        {
            /*
            fbLoginButton.delegate = self
            fbLoginButton.readPermissions = ["public_profile", "email", "user_friends", "user_birthday", "user_location", "user_education_history", "user_events"]
*/
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    /* Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        
    }
    */
    
    @IBAction func signInTapped(sender: AnyObject) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "email", "user_friends", "user_birthday", "user_location", "user_education_history", "user_events"], block: { (user, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print(error!.localizedDescription)
                return
                
            }
                
            else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                
                let liveFeedVC = self.storyboard?.instantiateViewControllerWithIdentifier("LiveFeedViewController") as! LiveFeedViewController
                
                let liveFeedPageNav = UINavigationController(rootViewController: liveFeedVC)
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.window?.rootViewController = liveFeedPageNav
            }
        })

    }

    
    
    /*
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
*/
    /*
    func customizeButton(button: UIButton!) {
        button.setBackgroundImage(nil, forState: .Normal)
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.blueColor().CGColor
    }
*/

}

