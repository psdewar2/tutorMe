//
//  LiveFeedViewController.swift
//  tutorMe
//
//  Created by Peyt Spencer Dewar on 1/23/16.
//  Copyright © 2016 PSD. All rights reserved.
//

import UIKit

class LiveFeedViewController: UIViewController {

    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var birthdayLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet weak var requestHelpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "name, id, email, birthday, location{name}"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                self.usernameLabel.text = String(userName)
                let userEmail : NSString = result.valueForKey("email") as! NSString
                self.emailLabel.text = String(userEmail)
                if let userBirthday : NSString = result.valueForKey("birthday") as? NSString {
                        self.birthdayLabel.text = String(userBirthday)
                } else {
                    self.birthdayLabel.removeFromSuperview()
                }
                
                if let locationDictionary = result.valueForKey("location") as? NSDictionary {
                let userLocation : NSString = locationDictionary.valueForKey("name") as! NSString
                self.locationLabel.text = String(userLocation)
                } else {
                    self.locationLabel.removeFromSuperview()
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutTapped(sender: AnyObject) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        
        let loginPageNav = UINavigationController(rootViewController: loginVC)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginPageNav
        print("Clicked")

    }

    @IBAction func requestHelpTapped(sender: AnyObject) {
        
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
