//
//  LogoutViewController.swift
//  Security Home
//
//  Created by Macintosh on 3/28/2559 BE.
//  Copyright © 2559 Mark Knapp. All rights reserved.
//

import UIKit
import Parse
class LogoutViewController: UIViewController {

    @IBOutlet weak var activity: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activity.hidden = true
        self.activity.stopAnimating()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        var refreshAlert = UIAlertController(title: "", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Log Out", style: .Destructive, handler: { (action: UIAlertAction!) in
            self.activity.hidden = false
            self.activity.startAnimating()
            var statuslogin = ""
            if let myLoadedString = NSUserDefaults.standardUserDefaults().stringForKey("statuslogin") {
                print(myLoadedString)
                statuslogin = myLoadedString
            }
            if statuslogin == "False"{
                self.activity.hidden = true
                self.activity.stopAnimating()
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginVC") as! UserLogin
                self.presentViewController(vc, animated: true, completion: nil)
            }
            
            var userName = ""
            if let myLoadedString = NSUserDefaults.standardUserDefaults().stringForKey("userName") {
                print(myLoadedString)
                userName = myLoadedString
            }

            
            let query = PFQuery(className: "Userkey")
            query.whereKey("Username", equalTo: userName)
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                for object in objects!{
                    object.deleteInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
                        if success{
                            self.activity.hidden = true
                            self.activity.stopAnimating()
                            NSUserDefaults.standardUserDefaults().setObject("False", forKey: "statuslogin")
                            NSUserDefaults.standardUserDefaults().setObject("", forKey: "userName")
                            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginVC") as! UserLogin
                            self.presentViewController(vc, animated: true, completion: nil)
                        }else{
                            self.activity.hidden = true
                            self.activity.stopAnimating()
                            var refreshAlert2 = UIAlertController(title: "", message: "Error delete information.", preferredStyle: UIAlertControllerStyle.Alert)
                            refreshAlert2.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                            
                            self.presentViewController(refreshAlert2, animated: true, completion: nil)
                            
                            
                            
                        }
                    })
                }
            })
         
            
            
    }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)

   
    }
    



}
