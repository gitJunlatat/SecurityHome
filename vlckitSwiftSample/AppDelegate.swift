//
//  AppDelegate.swift
//  vlckitSwiftSample
//
//  Created by Mark Knapp on 11/18/15.
//  Copyright © 2015 Mark Knapp. All rights reserved.
//

import UIKit
import PubNub
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PNObjectEventListener {
    
    var window:UIWindow?
    var client : PubNub
    var config : PNConfiguration
    let ch = singleton.sharedInstance.getUserKey()
    let _name = singleton.sharedInstance.getUserName()

    override init() {
        config = PNConfiguration(publishKey:"pub-c-52ae2e8d-acf1-442f-b12e-62d88a3491ef", subscribeKey:"sub-c-3454a9ae-aa15-11e5-a817-0619f8945a4f")
        client = PubNub.clientWithConfiguration(config)
        client.subscribeToChannels([ch+"GetLiveStreamControl",ch+"GetRecord",ch+"GetServo",ch+"GetSetting"], withPresence: false)
       
        super.init()
            client.addListener(self)
        
            }
 
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewControllerWithIdentifier("LoginVC") as! UserLogin
        self.window?.rootViewController = loginVC
        
     
        // Override point for customization after application launch.
        UITabBar.appearance().tintColor = UIColor.blueColor()
        
        
        Parse.enableLocalDatastore()
        Parse.setApplicationId("5yyYibbB2xBihd4obvV8w8ptIEpS8TJHJBNusF30", clientKey: "XfiFyA0QasruB3ZpAPmuzd43kUulCSLce0Ggx7i0")
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.addUniqueObject("pushNotification", forKey: "channels")
        currentInstallation.saveInBackground()
        

        // Register for Push Notitications
        if application.applicationState != UIApplicationState.Background {
            // Track an app open here if we launch with a push, unless
            // "content_available" was used to trigger a background push (introduced in iOS 7).
            // In that case, we skip tracking here to avoid double counting the app-open.
            
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        if #available(iOS 8.0, *) {
            let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
            let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        } else {
            let types: UIRemoteNotificationType = [.Alert, .Badge, .Sound]
            application.registerForRemoteNotificationTypes(types)
        }
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
       
        PFPush.handlePush(userInfo)
        print(userInfo)


        if application.applicationState == UIApplicationState.Inactive {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
            print(userInfo)
        }else if application.applicationState == UIApplicationState.Active{
            print("Active")
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                dispatch_async(dispatch_get_main_queue()) {
                    NSNotificationCenter.defaultCenter().postNotificationName("pullID", object: nil)
                    
                }
            }

        }
  

    }
    

    

    
    

   

    
    func publishDataX(_data:Int){
         var data = ["x" : String(_data),"name":_name]
         client.publish(data, toChannel: ch+"controlX", compressed: false, withCompletion: nil)
         print(data)
    }
    
    func publishDataY(_data:Int){
        var data = ["y" : String(_data),"name":_name]
        client.publish(data, toChannel: ch+"controlY", compressed: false, withCompletion: nil)
    }
    
    func publishGetLive(_data:String){
        var data = _data
        client.publish(data, toChannel: ch+"LiveStreamControl", compressed: false, withCompletion: nil)
    }
    
    func publishStreamRecord(_data:String){
        var data = _data
        print (data)
        client.publish(data, toChannel: ch+"Record", compressed: false, withCompletion: nil)
    }
    
    func publishSetting(_data:String){
        print(_data)
        client.publish(_data, toChannel: ch+"Setting", compressed: false, withCompletion: nil)

    }
    func publishDataXX(_data:String){
        client.publish(_data, toChannel: ch+"controlXY", compressed: false, withCompletion: nil)
    }

    
    
   
    func client(client: PubNub, didReceiveMessage message: PNMessageResult) {
       
        

    if (message.data.subscribedChannel! == ch+"GetRecord"){
        print("hannel ok")
        if (message.data.message!["recordStatus"]! as! String == "True"){
            singleton.sharedInstance.setstreamRecord(true)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                sleep(5)
                dispatch_async(dispatch_get_main_queue()) {
                    NSNotificationCenter.defaultCenter().postNotificationName("updateRecordID", object: nil)
                    
                }
            }
            
        }else{
            singleton.sharedInstance.setstreamRecord(false)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                dispatch_async(dispatch_get_main_queue()) {
                    NSNotificationCenter.defaultCenter().postNotificationName("updateRecordID", object: nil)
                    
                }
            }
        }
    }
    
    
    else if (message.data.subscribedChannel! == ch+"GetServo"){
        if(message.data.message!["servoLock"]! as! String != "") {
            singleton.sharedInstance.setLockBy(String(message.data.message!["servoLock"]! as! String))
            print("bobo "+singleton.sharedInstance.getLockBy())
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                dispatch_async(dispatch_get_main_queue()) {
                    NSNotificationCenter.defaultCenter().postNotificationName("updateStatusServoID", object: nil)
                    
                }
            }
            
        }else {
            singleton.sharedInstance.setLockBy("")
            print("null")
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                dispatch_async(dispatch_get_main_queue()) {
                    NSNotificationCenter.defaultCenter().postNotificationName("updateStatusServoID", object: nil)
                    
                }
            }
            
            
        }
    
    }
    
    
    else if (message.data.subscribedChannel! == ch+"GetLiveStreamControl"){
        
        
        
        
        if(message.data.message!["servoLock"]! as! String != "") {
            singleton.sharedInstance.setLockBy(String(message.data.message!["servoLock"]! as! String))
            print("bobo "+singleton.sharedInstance.getLockBy())
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                dispatch_async(dispatch_get_main_queue()) {
                    NSNotificationCenter.defaultCenter().postNotificationName("updateStatusServoID", object: nil)
                    
                }
            }
            
        }else {
            singleton.sharedInstance.setLockBy("")
            print("null")
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                dispatch_async(dispatch_get_main_queue()) {
                    NSNotificationCenter.defaultCenter().postNotificationName("updateStatusServoID", object: nil)
                    
                }
            }
            
        }
            if(message.data.message!["liveStatus"]! as! String == "True") {
                singleton.sharedInstance.setVidStreamStatus(true)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                sleep(5)
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        NSNotificationCenter.defaultCenter().postNotificationName("updateStatusStreamID", object: nil)

                    }
                }
            

            }else {
                singleton.sharedInstance.setVidStreamStatus(false)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    sleep(3)
                    dispatch_async(dispatch_get_main_queue()) {
                        NSNotificationCenter.defaultCenter().postNotificationName("updateStatusStreamID", object: nil)
                }
            }


        
    }
        
        // setAngleX
            if(message.data.message!["servoAngleX"]! as! String != "")  {
                var x:Int = Int(message.data.message!["servoAngleX"]! as! String)!
                singleton.sharedInstance.setAngleX(x)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        NSNotificationCenter.defaultCenter().postNotificationName("updateServoAngleXID", object: nil)
                    
                    }
                
            }
        }
        // setAngleY
       
            if(message.data.message!["servoAngleY"]! as! String != "") {
                var y:Int = Int(message.data.message!["servoAngleY"]! as! String)!
                singleton.sharedInstance.setAngleY(y)
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    dispatch_async(dispatch_get_main_queue()) {
                        NSNotificationCenter.defaultCenter().postNotificationName("updateServoAngleYID", object: nil)
                    
                }
            
        }
        }
        
        
    
    }

    
    
   //


 
    }
   
    
    
    
    

    func applicationWillResignActive(application: UIApplication) {
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    

}

