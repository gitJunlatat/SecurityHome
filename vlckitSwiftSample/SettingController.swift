//
//  SettingController.swift
//  vlckitSwiftSample
//
//  Created by Macintosh on 3/10/2559 BE.
//  Copyright © 2559 Mark Knapp. All rights reserved.
//

import UIKit

import SwiftyUserDefaults
import SwiftySettings

class Storage : SettingsStorageType {
    
    subscript(key: String) -> Bool? {
        get {
            return Defaults[key].bool
        }
        set {
            Defaults[key] = newValue
        }
    }
    subscript(key: String) -> Float? {
        get {
            return Float(Defaults[key].doubleValue)
        }
        set {
            Defaults[key] = newValue
        }
    }
    subscript(key: String) -> Int? {
        get {
            return Defaults[key].int
        }
        set {
            Defaults[key] = newValue
        }
    }
    subscript(key: String) -> String? {
        get {
            return Defaults[key].string
        }
        set {
            Defaults[key] = newValue
        }
    }
}


class SettingController :SwiftySettingsViewController{
    var storage = Storage()
    var appDel = AppDelegate()
    var progressIcon = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettingsTopDown()
        print(Defaults["light1"].string)
        print(Defaults[""].string)
        print("yo  \(Defaults["human"].bool!)")
        print(Defaults["qualityRecord"].int!)
        
        
        self.progressIcon.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.progressIcon.color = UIColor.redColor()
        self.view.addSubview(self.progressIcon)
        self.progressIcon.frame = CGRectMake(525, 400, 0, 0)
        self.progressIcon.startAnimating()
        
        let myFirstButton = UIButton()
        myFirstButton.setTitle("Done", forState: .Normal)
        myFirstButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        myFirstButton.frame = CGRectMake(970, 25, 46, 30)
        myFirstButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        self.view.addSubview(myFirstButton)
        
    }
    func pressed(sender: UIButton!) {

        var human = "False"
        var fire = "False"
        var gasAndSmoke = "False"
        
        var qualityLive = ""
        var fpsLive = ""
        
        var qualityRecord = ""
        var fpsRecord = ""
        var timeOfRecord = ""

        
        if Defaults["human"].bool! == true{
            human = "True"
        }
        if Defaults["fire"].bool! == true{
            fire = "True"
        }
        if Defaults["gas&smoke"].bool! == true{
            gasAndSmoke = "True"
        }
        
        
        if Defaults["qualityLive"].int == nil{
            qualityLive = "320,240"
        }else if Defaults["qualityLive"].int! == 1{
            qualityLive = "192,144"
        }else if Defaults["qualityLive"].int! == 2{
            qualityLive = "320,240"
        }else if Defaults["qualityLive"].int! == 3{
            qualityLive = "480,360"
        }else if Defaults["qualityLive"].int! == 4{
            qualityLive = "640,480"
        }else if Defaults["qualityLive"].int! == 5{
            qualityLive = "1280,720"
        }
        
        
        if Defaults["fpsLive"].int == nil{
            fpsLive = "25"
        }else if Defaults["fpsLive"].int! == 1{
            fpsLive = "10"
        }else if Defaults["fpsLive"].int! == 2{
            fpsLive = "15"
        }else if Defaults["fpsLive"].int! == 3{
            fpsLive = "20"
        }else if Defaults["fpsLive"].int! == 4{
            fpsLive = "25"
        }else if Defaults["fpsLive"].int! == 5{
            fpsLive = "30"
        }
        
        
        if Defaults["qualityRecord"].int == nil{
            qualityRecord = "320,240"
        }else if Defaults["qualityRecord"].int! == 1{
            qualityRecord = "192,144"
        }else if Defaults["qualityRecord"].int! == 2{
            qualityRecord = "320,240"
        }else if Defaults["qualityRecord"].int! == 3{
            qualityRecord = "480,360"
        }else if Defaults["qualityRecord"].int! == 4{
            qualityRecord = "640,480"
        }else if Defaults["qualityRecord"].int! == 5{
            qualityRecord = "1280,720"
        }
        
        if Defaults["fpsRecord"].int == nil{
            fpsRecord = "25"
        }
        else if Defaults["fpsRecord"].int! == 1{
            fpsRecord = "10"
        }else if Defaults["fpsRecord"].int! == 2{
            fpsRecord = "15"
        }else if Defaults["fpsRecord"].int! == 3{
            fpsRecord = "20"
        }else if Defaults["fpsRecord"].int! == 4{
            fpsRecord = "25"
        }else if Defaults["fpsRecord"].int! == 5{
            fpsRecord = "30"
        }
        
        
        if Defaults["timeRecord"].int == nil{
            timeOfRecord = "15"
        }
        else if Defaults["timeRecord"].int! == 1{
            timeOfRecord = "15"
        }else if Defaults["timeRecord"].int! == 2{
            timeOfRecord = "30"
        }else if Defaults["timeRecord"].int! == 3{
            timeOfRecord = "45"
        }else if Defaults["timeRecord"].int! == 4{
            timeOfRecord = "60"
        }

        print(human)
        print(fire)
        print(gasAndSmoke)
        print(qualityLive)
        print(fpsLive)
        print(qualityRecord)
        print(fpsRecord)
        print(timeOfRecord)
        
        var data = ["Human":human,
                "Fire":fire,
                "gasAndSmoke":gasAndSmoke,
                "qualityLive":qualityLive,
                "qualityRecord":qualityRecord,
                "fpsLive":fpsLive,
                "fpsRecord":fpsRecord,
                "timeOfRecord":timeOfRecord]
        print(data)
        
        var refreshAlert = UIAlertController(title: "", message: "Are you sure you want to change the settings?", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            self.progressIcon.hidden = false
            self.progressIcon.startAnimating()
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                self.appDel.publishSetting("Human,"+human+",")
                self.appDel.publishSetting("Fire,"+fire+",")
                self.appDel.publishSetting("GasAndSmoke,"+gasAndSmoke+",")
                self.appDel.publishSetting("QualityLive,"+qualityLive)
                self.appDel.publishSetting("fpsLive,"+fpsLive+",")
                self.appDel.publishSetting("QualityRecord,"+qualityRecord)
                self.appDel.publishSetting("fpsRecord,"+fpsRecord+",")
                self.appDel.publishSetting("timeOfRecord,"+timeOfRecord+",")
                sleep(2)
                dispatch_async(dispatch_get_main_queue()) {
                    self.progressIcon.hidden = true
                    self.progressIcon.stopAnimating()
                  /*  let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabBar = storyboard.instantiateViewControllerWithIdentifier("tabBar") as! UITabBarController
                    let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDel.window?.rootViewController = tabBar
*/
                }
            }

        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Destructive, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
            self.progressIcon.hidden = true
            self.progressIcon.stopAnimating()
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)

        
        
        
        
        
        
        
    }
    func updateSetting(notification:NSNotification){
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.progressIcon.hidden = true
        self.progressIcon.stopAnimating()
    }
    
    override func viewDidDisappear(animated: Bool) {
        print("call")
    }
    
    func loadSettingsTopDown() {
        /* Top Down settings */
        settings = SwiftySettings(storage: storage, title: "Security Home") {
            
            [Section(title: "SETTING") {
                [Screen(title: "Remote Notification") {
                        [Section(title: "") {
                            [Switch(key: "human", title: "Intruder Notification"),
                                Switch(key: "fire", title: "Fire Notification"),
                                Switch(key: "gas&smoke", title: "Gas&Smoke Notification"),
                            ]
                        }]
                    },
                  ]
                },
                Section(title: "LIVE VIDEO") {
                            [OptionsButton(key: "qualityLive", title: "Quality") {
                                
                                [Option(title: "144p", optionId: 1),
                                Option(title: "240p", optionId: 2),
                                Option(title: "360p", optionId: 3),
                                Option(title: "480p", optionId: 4),
                                Option(title: "720p", optionId: 5),]
                                },
                                OptionsButton(key: "fpsLive", title: "Fps") {
                                       [Option(title: "10", optionId: 1),
                                        Option(title: "15", optionId: 2),
                                        Option(title: "20", optionId: 3),
                                        Option(title: "25", optionId: 4),
                                        Option(title: "30", optionId: 5),]
                                }
                        ]
                },
                Section(title: "RECORD VIDEO") {
                    [OptionsButton(key: "qualityRecord", title: "Quality") {
                        [Option(title: "144p", optionId: 1),
                            Option(title: "240p", optionId: 2),
                            Option(title: "360p", optionId: 3),
                            Option(title: "480p", optionId: 4),
                            Option(title: "720p", optionId: 5),]
                        },
                        OptionsButton(key: "fpsRecord", title: "Fps") {
                            [Option(title: "10", optionId: 1),
                                Option(title: "15", optionId: 2),
                                Option(title: "20", optionId: 3),
                                Option(title: "25", optionId: 4),
                                Option(title: "30", optionId: 5),]
                        },
                        OptionsButton(key: "timeRecord", title: "Time of Record") {
                               [Option(title: "15 second", optionId: 1),
                                Option(title: "30 second", optionId: 2),
                                Option(title: "45 second", optionId: 3),
                                Option(title: "60 second", optionId: 4),]
                            },
                    ]
                },

                
            ]
        }
    }
    
}


