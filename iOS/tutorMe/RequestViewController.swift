//
//  RequestViewController.swift
//  tutorMe
//
//  Created by Peyt Spencer Dewar on 1/24/16.
//  Copyright © 2016 PSD. All rights reserved.
//

import UIKit

class RequestViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var courseHelpView: UIPickerView!
    @IBOutlet weak var postRequestButton: UIButton!
    
    var pickerDataSource = ["Accounting","Algebra I", "Algebra II","World History","Biology","Calculus I", "Calculus II","Geometry", "General Chemistry",
        "Organic Chemistry", "Physics I", "Physics II", "Digital Logic","Real Estate",
        "Finance Management","Construction Management","American Literature","Criminal Law","Entomology","Neuropsychology",
        "Sociology","Product Design","Artificial Intelligence","Social Studies","Astronomy"
        ,"Rocket Science", "What Is The Good Life?"]
    var selectedRow = "Accounting"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.courseHelpView.dataSource = self;
        self.courseHelpView.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerDataSource[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        selectedRow = pickerDataSource[row]
    }
    
    @IBAction func onButtonTapped(sender: AnyObject) {
        let postToCreate = PFObject(className: "Post")
        
        postToCreate["first_name"] = PFUser.currentUser()!.objectForKey("first_name")
        
        postToCreate["subject"] = selectedRow
        
        postToCreate.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved. Now return to timeline
                let liveFeed = self.storyboard?.instantiateViewControllerWithIdentifier("LiveFeedNavController") as! UINavigationController
                self.presentViewController(liveFeed, animated: true, completion: nil)
            } else {
                // There was a problem, check error.description
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
