//
//  LiveFeedViewController.swift
//  tutorMe
//
//  Created by Peyt Spencer Dewar on 1/23/16.
//  Copyright © 2016 PSD. All rights reserved.
//

import UIKit
import Parse

class LiveFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var helpTableView: UITableView!
    var helpArray = NSMutableArray()
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    //@IBOutlet var birthdayLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet weak var requestHelpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.helpTableView.dataSource = self
        self.helpTableView.delegate = self
        let userParameters = ["fields": "name, id, email, first_name, last_name, birthday, location{name}"]
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: userParameters)
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
                let userFirstName = result.valueForKey("first_name") as? String
                let userLastName = result.valueForKey("last_name") as? String
                
                let userEmail = result.valueForKey("email") as? String
                self.emailLabel.text = userEmail
                /*
                if let userBirthday : NSString = result.valueForKey("birthday") as? NSString {
                        self.birthdayLabel.text = String(userBirthday)
                } else {
                    self.birthdayLabel.removeFromSuperview()
                }
                */
                
                if let locationDictionary = result.valueForKey("location") as? NSDictionary {
                let userLocation : NSString = locationDictionary.valueForKey("name") as! NSString
                self.locationLabel.text = String(userLocation)
                } else {
                    self.locationLabel.removeFromSuperview()
                }
                
                if PFUser.currentUser() == nil {
                    print("Hi you suck")
                } else {
                    let currentUser:PFUser = PFUser.currentUser()!
                    
                    //Save first name
                    if (userFirstName != nil) {
                        currentUser.setObject(userFirstName!, forKey: "first_name")
                    }
                    //Save last name
                    if (userLastName != nil) {
                        currentUser.setObject(userLastName!, forKey: "last_name")
                    }
                    //Save email
                    if (userEmail != nil) {
                        currentUser.setObject(userEmail!, forKey: "email")
                    }
                    
                    currentUser.saveInBackgroundWithBlock({(success:Bool, error:NSError?) -> Void in
                        if (success) {
                            print("User details are now updated")
                        }
                    })

                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //reloads data before even appearing in the view
        retrieveDataFromParse()
        self.helpTableView.reloadData()
        
        
        // actIndicator.hidden = true // for now
        
    }
    
    @IBAction func logoutTapped(sender: AnyObject) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        PFUser.logOutInBackgroundWithBlock { (error:NSError?) -> Void in
            
            let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        
            let loginPageNav = UINavigationController(rootViewController: loginVC)
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.window?.rootViewController = loginPageNav
            print("Clicked")
        }

    }

    @IBAction func requestHelpTapped(sender: AnyObject) {
        
    }
    
    //DataSourceSegment////////////////
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helpArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //get offer/request
        let tempObject:PFObject = self.helpArray.objectAtIndex(indexPath.row) as! PFObject
        let postCreator = tempObject["first_name"] as! String  // get first name of user from post
        let subject = tempObject["subject"] as! String
        let userQuery:PFQuery = PFUser.query()! // access user class
        userQuery.whereKey("username", equalTo: postCreator) // find user == postCreator
        
        let hCell:HelpViewCell = tableView.dequeueReusableCellWithIdentifier("HelpViewCell") as! HelpViewCell
        
        hCell.helpTextLabel.text = "Needs help in \(subject)."
        hCell.helpFirstNameLabel.text = postCreator
        
        return hCell
    }

    
    func retrieveDataFromParse()
    {
        //get query from parse
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            //query parse object and put each object in objects array
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil
            {
                self.helpArray.removeAllObjects()
                //populate myPostArray with each parse objects
                if let objects = objects {
                    for object in objects {
                        print(object.objectId, terminator: "")
                        self.helpArray.addObject(object)
                    }
                }
                
                self.helpTableView.reloadData()
                               // The find succeeded.
                print("Successfully retrieved \(objects!.count) posts.", terminator: "")
            }
            else
            {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)", terminator: "")
            }
        }
        
        
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
