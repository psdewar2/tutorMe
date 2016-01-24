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

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet var fbLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
            fbLoginButton.delegate = self
            fbLoginButton.readPermissions = ["public_profile", "email", "user_friends", "user_birthday", "user_location", "user_education_history", "user_events"]
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
            print(error.localizedDescription)
            return
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            print("Token is \(FBSDKAccessToken.currentAccessToken().tokenString)")
            print("User ID is \(FBSDKAccessToken.currentAccessToken().userID)")
            
            let liveFeedVC = self.storyboard?.instantiateViewControllerWithIdentifier("LiveFeedViewController") as! LiveFeedViewController
            
            let liveFeedPageNav = UINavigationController(rootViewController: liveFeedVC)
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController = liveFeedPageNav
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }

}

