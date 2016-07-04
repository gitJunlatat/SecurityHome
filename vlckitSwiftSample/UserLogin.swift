//
//  UserLogin.swift
//  vlckitSwiftSample
//
//  Created by Macintosh on 3/10/2559 BE.
//  Copyright © 2559 Mark Knapp. All rights reserved.
//

import UIKit
import Parse
import TextFieldEffects
class UserLogin: UIViewController,UITextFieldDelegate {
    



   // @IBOutlet weak var activity: UIActivityIndicatorView!
   // @IBOutlet weak var viewActivity: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var viewActivity: UIView!
    @IBOutlet weak var rememberme: UIButton!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var keyImage: UIImageView!
    @IBOutlet weak var userName: YoshikoTextField!
    @IBOutlet weak var userKey: YoshikoTextField!
    @IBOutlet var scrollView: UIScrollView!
    var imageLabel:UIImageView!
    var statusRemember = false
    @IBOutlet var textUser: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  NSUserDefaults.standardUserDefaults().setObject("", forKey: "userKey")
      //  NSUserDefaults.standardUserDefaults().setObject("", forKey: "userName")
      
    
   
        let data = UIImage(named: "logonew.jpg")
        imageLabel = UIImageView(image: data)
        imageLabel.frame =  CGRect(x: 332, y: 295, width: 361, height: 195)
        self.view.addSubview(imageLabel)
        /*var gameScore = PFObject(className:"Userkey")
        gameScore["key"] = "UxT13X98J2ab"

        gameScore.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
            */
        
    }
    
    
    override func viewDidLayoutSubviews() {
    }
    
    override func viewDidAppear(animated: Bool) {
        var statuslogin = ""
        if let myLoadedString = NSUserDefaults.standardUserDefaults().stringForKey("statuslogin") {
            print(myLoadedString)
            statuslogin = myLoadedString
        }
        if statuslogin == "True"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBar = storyboard.instantiateViewControllerWithIdentifier("tabBar") as! UITabBarController
            let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
            appDel.window?.rootViewController = tabBar
        }
        
        self.viewActivity.hidden = true
        self.activity.hidden = true
        self.activity.stopAnimating()
        UIView.animateWithDuration(1.3) { () -> Void in
            self.imageLabel.center = CGPointMake(self.imageLabel.center.x, self.imageLabel.center.y-173)
   
        }
        UIView.animateWithDuration(3) { () -> Void in
            self.login.alpha = 1.0
            self.userImage.alpha = 1.0
            self.keyImage.alpha = 1.0
            self.userName.alpha = 1.0
            self.userKey.alpha = 1.0
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
            scrollView.setContentOffset(CGPointMake(0, 120), animated: true)
        UIView.animateWithDuration(0.2) { () -> Void in
            self.imageLabel.center = CGPointMake(self.imageLabel.center.x, self.imageLabel.center.y-100)
        }
        
    
    }
    func textFieldDidEndEditing(textField: UITextField) {
            scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        UIView.animateWithDuration(0.2) { () -> Void in
            self.imageLabel.center = CGPointMake(self.imageLabel.center.x, self.imageLabel.center.y+100)
        }

    }
    
    @IBAction func loginAction(sender: AnyObject) {
        //self.viewActivity.hidden = false
        //self.activity.hidden = false
        //self.activity.startAnimating()
        self.viewActivity.hidden = false
        self.activity.hidden = false
        self.activity.startAnimating()
        if ((self.userKey.text!.isNotEmpty) == true && (self.userName.text?.isNotEmpty) == true ){
            
            
            
            let query = PFQuery(className: "Userkey")
            print("oksssssss"+self.userKey.text!)
            query.whereKey("key", equalTo: self.userKey.text!)
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                if error == nil{
                    if objects!.count > 0 {
                        print("found")
                        let query2 = PFQuery(className: "Userkey")
                        query2.whereKey("Username", equalTo: self.userName.text!)
                        query2.findObjectsInBackgroundWithBlock({ (object2:[PFObject]?, error2:NSError?) -> Void in
                            if error2 == nil{
                                if object2?.count > 0{
                                    let alertView = UIAlertController(title: "", message: "Username already exists.", preferredStyle: .Alert)
                                    alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                                    self.presentViewController(alertView, animated: true, completion: nil)
                                    self.viewActivity.hidden = true
                                    self.activity.hidden = true
                                    self.activity.stopAnimating()
                                }else{
                                    if self.statusRemember == true{
                                        NSUserDefaults.standardUserDefaults().setObject("True", forKey: "statuslogin")
                                        NSUserDefaults.standardUserDefaults().setObject(self.userName.text!, forKey: "userName")
                                        
                                        let testObject = PFObject(className: "Userkey")
                                        testObject["Username"] = self.userName.text!
                                        testObject.saveInBackgroundWithBlock { (success: Bool, error3: NSError?) -> Void in
                                            if success{
                                            print("Object has been saved.")
                                            }else{
                                                print(error3)
                                            }
                                        }

                                    }else{
                                    NSUserDefaults.standardUserDefaults().setObject("False", forKey: "statuslogin")
                                    }
                                    
                                    
                                    self.viewActivity.hidden = true
                                    self.activity.hidden = true
                                    self.activity.stopAnimating()
                                    singleton.sharedInstance.setUserKey(self.userKey.text!)
                                    singleton.sharedInstance.SetUserName(self.userName.text!)
                                    
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let tabBar = storyboard.instantiateViewControllerWithIdentifier("tabBar") as! UITabBarController
                                    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
                                    appDel.window?.rootViewController = tabBar

                                
                                }
                            }
                        })
                        
                        

                                            }else{
                        print("not found")
                        self.viewActivity.hidden = true
                        self.activity.hidden = true
                        self.activity.stopAnimating()

                        
                        let alertView = UIAlertController(title: "", message: "Invalid Userkey", preferredStyle: .Alert)
                        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                        self.presentViewController(alertView, animated: true, completion: nil)
                        
                    }
                    
                }else{
                    print("error query")
                    self.viewActivity.hidden = true
                    self.activity.hidden = true
                    self.activity.stopAnimating()
                    let alertView = UIAlertController(title: "", message: "Error Connected.", preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(alertView, animated: true, completion: nil)

                }
                
            })

            

        }else{
           // self.viewActivity.hidden = true
            //self.activity.hidden = true
            //self.activity.stopAnimating()
            self.viewActivity.hidden = true
            self.activity.hidden = true
            self.activity.stopAnimating()
            
            print("please enter userkey")
            let alertView = UIAlertController(title: "", message: "Please complete the following information", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alertView, animated: true, completion: nil)
            
        }
    

    
             /*

      */
    }
    @IBAction func rememberMe(sender: AnyObject)
    {
        print(self.statusRemember)
        if statusRemember == false{
            var image = UIImage(named: "c.png")
            self.rememberme.setImage(image, forState: UIControlState.Normal)
            self.statusRemember = true
        }else{
            var image2 = UIImage(named: "u.png")
            self.rememberme.setImage(image2, forState: UIControlState.Normal)
            self.rememberme.backgroundColor = UIColor.whiteColor()
            self.rememberme.tintColor = UIColor.grayColor()
            self.statusRemember = false
            
        }
    }
    
}
