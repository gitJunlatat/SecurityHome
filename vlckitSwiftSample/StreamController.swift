//
//  ViewController.swift
//  vlckitSwiftSample
//
//  Created by Mark Knapp on 11/18/15.
//  Copyright © 2015 Mark Knapp. All rights reserved.
//

import UIKit
import PubNub
import CDJoystick
import Parse
import Bolts
import ReplayKit
import AssetsLibrary
import AVFoundation



class StreamController: UIViewController,RPPreviewViewControllerDelegate,UITabBarDelegate{
    var library:ALAssetsLibrary = ALAssetsLibrary()
    var audioPlayer = AVAudioPlayer()
    @IBOutlet weak var btnSetAngle: UIButton!
    @IBOutlet weak var activityStream: UIActivityIndicatorView!
    @IBOutlet weak var stopRecord: UIButton!
    @IBOutlet weak var waitServo: UIActivityIndicatorView!
    @IBOutlet var xDataView: UITextField!
    @IBOutlet var yDataView: UITextField!
    @IBOutlet weak var lockBy: UILabel!
    @IBOutlet weak var lockServo: UISwitch!
    var checkcall:Bool = false
    var appDel = AppDelegate()
    let joystick = CDJoystick()
    var movieView: UIView!
    var mediaPlayer = VLCMediaPlayer()
    var mx:Int = 0
    var my:Int = 0
    var statusServo:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")

        

        self.activityStream.hidden = false
        self.activityStream.startAnimating()
        
        lockBy.hidden = true
        waitServo.hidden = false
        waitServo.startAnimating()
        //self.lockServo.tintColor = UIColor.redColor()
        //self.lockServo.layer.cornerRadius = 16
        //self.lockServo.backgroundColor = UIColor.redColor()
        self.stopRecord.hidden = true
        self.btnSetAngle.layer.cornerRadius = 5
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateStatusStream:", name: "updateStatusStreamID", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateStatusServo:", name: "updateStatusServoID", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateServoAngleX:", name: "updateServoAngleXID", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateServoAngleY:", name: "updateServoAngleYID", object: nil)
        
        let currentInstallation = PFInstallation.currentInstallation()
    currentInstallation.addUniqueObject("pushNotification", forKey: "channels")
        currentInstallation.saveInBackground()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        //Setup movieView
        self.movieView = UIView()
        self.movieView.backgroundColor = UIColor.blackColor()
        //Add tap gesture to movieView for play/pause
        self.movieView.frame = CGRectMake(90, 150, 560, 400)

    
        let gesture = UITapGestureRecognizer(target: self, action: "movieViewTapped:")
       // self.movieView.addGestureRecognizer(gesture)
        
        //Add movieView to view controller

        self.view.addSubview(self.movieView)
        
        
        joystick.backgroundColor = .clearColor()
        joystick.substrateColor = .lightGrayColor()
        joystick.substrateBorderColor = .grayColor()
        joystick.substrateBorderWidth = 1.0
        joystick.stickSize = CGSize(width: 50, height: 50)
        joystick.stickColor = .darkGrayColor()
        joystick.stickBorderColor = .blackColor()
        joystick.frame = CGRect(x: 770, y: 400, width: 160, height: 160)
        joystick.stickBorderWidth = 2.0
        joystick.fade = 0.5
        joystick.trackingHandler = { (joystickData) -> () in
            
            if (singleton.sharedInstance.getLockBy() == "True" || singleton.sharedInstance.getLockBy() == singleton.sharedInstance.getUserName() || singleton.sharedInstance.getLockBy() == "")  {
            
                if (Int(joystickData.velocity.x) != 0){
                    print(Int(joystickData.velocity.x))
                    if (self.mx <= 0 && Int(joystickData.velocity.x) < 0 ){
                        print("the angle is limit at 0 ")
                    }else if (self.mx >= 180 && Int(joystickData.velocity.x) > 0){
                        print("the angle x is limit at 180")
                    }else {
                        self.mx = Int(joystickData.velocity.x) + self.mx
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.appDel.publishDataX(Int(joystickData.velocity.x))

                                self.xDataView.text = "\(self.mx)"
                            }
                        }
                    }
                }
            }else{
            
                if singleton.sharedInstance.getLockBy() == "0000000000"{
                    let alertView = UIAlertController(title: "", message: "Servo  is busy.", preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(alertView, animated: true, completion: nil)
                }else{
                    self.alertServo()
                    
                }
                
                
            }
            
                
                
              
                
                
        if (singleton.sharedInstance.getLockBy() == "True" || singleton.sharedInstance.getLockBy() == singleton.sharedInstance.getUserName() || singleton.sharedInstance.getLockBy() == "" )  {
            
            if (Int(-joystickData.velocity.y) != 0){
            if (self.my <= 0 && Int(-joystickData.velocity.y) < 0 ){
                print("the angle  is limit at 0 ")
            }else if (self.my >= 170 && Int(-joystickData.velocity.y) > 0){
                print("the angle y is limit at 70")
            }else{
                self.my = Int(-joystickData.velocity.y) + self.my
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.appDel.publishDataY(Int(-joystickData.velocity.y))

                        self.yDataView.text = "\(self.my)"
                    }
                }
            }
            }
        }else{
            if singleton.sharedInstance.getLockBy() == "0000000000"{
                let alertView = UIAlertController(title: "", message: "Servo  is busy.", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
            }else{
                self.alertServo()

            }
            }
            
        
        }
        view.addSubview(joystick)
    
    }
    

    
    override func viewWillAppear(animated: Bool) {
        print("view will appear")
        viewDidAppear(true)
    }

    override func viewDidAppear(animated: Bool) {
            print("view did apprear")
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

                dispatch_async(dispatch_get_main_queue()) {
                    self.appDel.publishGetLive("getLive,")

                }
            }


        
        //Playing multicast UDP (you can multicast a video from VLC)
        //let url = NSURL(string: "udp://@225.0.0.1:51018")
        self.activityStream.hidden = false
        self.activityStream.startAnimating()

        lockBy.hidden = true
        waitServo.hidden = false
        waitServo.startAnimating()
        self.view.addSubview(self.activityStream)

        //Playing HTTP from internet
       // let url = NSURL(string: "http://streams.videolan.org/streams/mp4/Mr_MrsSmith-h264_aac.mp4")
        //Playing RTSP from internet
        let url = NSURL(string: "https://www.youtube.com/watch?v=sY7OgsdiXHc")
        let media = VLCMedia(URL: url)
        mediaPlayer.setMedia(media)
        mediaPlayer.setDelegate(self)
        
        mediaPlayer.drawable = self.movieView
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(animated: Bool) {
               
    }
    override func viewDidDisappear(animated: Bool) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            dispatch_async(dispatch_get_main_queue()) {
                self.appDel.publishGetLive("liveStop,")
                self.appDel.publishGetLive("servoUnlock,")

                print("stopStream")
            }
        }


    }
    
    @IBAction func servoLockStatus(sender: AnyObject) {
        lockBy.hidden = true
        waitServo.hidden = false
        waitServo.startAnimating()
        if self.lockServo.on != true{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.appDel.publishGetLive("servoLock,"+singleton.sharedInstance.getUserName())
                    
                }
            }
        }
        else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.appDel.publishGetLive("servoUnlock,")
                    
                }
            }
        }
    }
    

    func updateServoAngleX(notification:NSNotification){
        self.mx = singleton.sharedInstance.getAngleX()
        self.xDataView.text = String(mx)
        
        
    }
    func updateServoAngleY(notification:NSNotification){
        self.my = singleton.sharedInstance.getAngleY()
        self.yDataView.text = String(my)

    
    }
    
    @IBAction func btnSetAngle(sender: AnyObject) {
        
        if (singleton.sharedInstance.getLockBy() == "True" || singleton.sharedInstance.getLockBy() == singleton.sharedInstance.getUserName() || singleton.sharedInstance.getLockBy() == "" ){
            
       if var x = Int(self.xDataView.text!) , y = Int(self.yDataView.text!)  {
        self.appDel.publishDataXX("x,"+String(x))
        self.appDel.publishDataXX("y,"+String(y))
        self.mx = x
        self.my = y
       }else{
        let alertView = UIAlertController(title: "Warnning", message: "Invalid value for set angle \(singleton.sharedInstance.getLockBy())", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }
        }else{
            if singleton.sharedInstance.getLockBy() == "0000000000"{
                let alertView = UIAlertController(title: "", message: "Servo  is busy.", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alertView, animated: true, completion: nil)
            }else{
                alertServo()
                
            }
        
        
        }
        
    }

    func updateStatusServo(notification:NSNotification){
        var _servoLockBy:String = singleton.sharedInstance.getLockBy()
        print("S \(_servoLockBy)")
        if _servoLockBy == "0000000000"{
            print("lock")
            self.lockServo.setOn(false, animated: true)
            self.lockBy.text = "SERVO IS BUSY"
            self.lockBy.textColor = UIColor.redColor()
            lockBy.hidden = false
            waitServo.hidden = true
            waitServo.stopAnimating()
        }else if _servoLockBy == "True"{
            print("available")
            self.lockServo.setOn(true, animated: true)
            self.lockBy.text = "AVAILABLE"
            self.lockBy.textColor = UIColor(red: 0, green: 153/255.0, blue: 0, alpha: 1)
            lockBy.hidden = false
            waitServo.hidden = true
            waitServo.stopAnimating()
        }else if _servoLockBy == ""{
            print("available")
            self.lockServo.setOn(true, animated: true)
            self.lockBy.text = "AVAILABLE"
            self.lockBy.textColor = UIColor(red: 0, green: 153/255.0, blue: 0, alpha: 1)
            lockBy.hidden = false
            waitServo.hidden = true
            waitServo.stopAnimating()
        }else{
            self.lockServo.setOn(false, animated: true)
            self.lockBy.text = "[\(_servoLockBy)]"
            self.lockBy.textColor = UIColor.redColor()
            lockBy.hidden = false
            waitServo.hidden = true
            waitServo.stopAnimating()
        }
    }
    
    func updateStatusStream(notification:NSNotification){
        var statusStream = singleton.sharedInstance.getVidStreamStatus()
        if statusStream  == true{
            print("play")
            mediaPlayer.play()
            self.activityStream.stopAnimating()
            self.activityStream.hidden = true
            
            
        }else{
            mediaPlayer.stop()
            self.activityStream.stopAnimating()
            self.activityStream.hidden = true
            let alertView = UIAlertController(title: "Warnning", message: "Camera is busy", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alertView, animated: true, completion: nil)
        }
    }
    
    
    func alertServo(){
        let alertView = UIAlertController(title: "Warnning", message: "servo lock by \(singleton.sharedInstance.getLockBy())", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
    }

    
    

    @IBAction func captureBtn(sender: AnyObject) {
        if mediaPlayer.isPlaying(){
        var player = AVAudioPlayer()
        
        let url:NSURL = NSBundle.mainBundle().URLForResource("captureM", withExtension: "mp3")!
        
        do { player = try AVAudioPlayer(contentsOfURL: url, fileTypeHint: nil) }
        catch let error as NSError { print(error.description) }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            player.numberOfLoops = 1
            player.prepareToPlay()
            player.play()
            sleep(3)
            dispatch_async(dispatch_get_main_queue()) {

            }
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(560,400), false, 0);
        self.view.drawViewHierarchyInRect(CGRectMake(-90,-150,view.bounds.size.width,view.bounds.size.height), afterScreenUpdates: true)
        var image:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        saveImageToAlbum(image)
        }else{
            let alertView = UIAlertController(title: "Warnning", message: "Not found video playing", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alertView, animated: true, completion: nil)
        }
        
    }
    
    
    
    @IBAction func stopRecord(sender: AnyObject) {
        self.joystick.hidden = false
        self.tabBarController?.tabBar.hidden = false
        let recorder = RPScreenRecorder.sharedRecorder()
        self.movieView.frame = CGRectMake(90, 150, 560, 400)
        recorder.stopRecordingWithHandler { [unowned self] (preview, error) in
            self.stopRecord.hidden = true
            
            if let unwrappedPreview = preview {
                //unwrappedPreview.previewControllerDelegate = self
                unwrappedPreview.popoverPresentationController?.sourceView = self.view
                
                self.presentViewController(unwrappedPreview, animated: true, completion: nil)
            }
            print(RPScreenRecorder.sharedRecorder().available)
        }
        
        
        
    }
    
    @IBAction func recordVideo(sender: AnyObject) {
        if mediaPlayer.isPlaying() {
            // self.movieView.frame = self.view.frame
            let recorder = RPScreenRecorder.sharedRecorder()
            
            self.movieView.addSubview(self.stopRecord)
            self.movieView.frame = self.view.frame
            self.stopRecord.hidden = true
            self.joystick.hidden = true
            self.tabBarController?.tabBar.hidden = true
            
            recorder.startRecordingWithMicrophoneEnabled(true) { [unowned self] (error) in
                if let unwrappedError = error {
                    print(unwrappedError.localizedDescription)
                } else {
                    self.stopRecord.hidden = false



                }
                
            }
        }else{
            let alertView = UIAlertController(title: "Warnning", message: "Not found video playing", preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(alertView, animated: true, completion: nil)
        }
    }
    
    func previewControllerDidFinish(previewController: RPPreviewViewController) {
       dismissViewControllerAnimated(true, completion: nil)
     }

    
    func saveImageToAlbum(imageData:UIImage)
        {
            let image:UIImage = imageData
            library.writeImageToSavedPhotosAlbum(image.CGImage, orientation: ALAssetOrientation(rawValue:
                image.imageOrientation.rawValue)!, completionBlock:saveDone)
        }
        
    func saveDone(assetURL:NSURL!, error:NSError!){
            print("saveDone")
            library.assetForURL(assetURL, resultBlock: self.saveToAlbum, failureBlock: nil)
        }
        
        
    func saveToAlbum(asset:ALAsset!){
            library.enumerateGroupsWithTypes(ALAssetsGroupAlbum, usingBlock: { group, stop in stop.memory = false
                if(group != nil){
                    let str = group.valueForProperty(ALAssetsGroupPropertyName) as! String
                    if(str == "MY_ALBUM_NAME"){
                        group!.addAsset(asset!)
                        let assetRep:ALAssetRepresentation = asset.defaultRepresentation()
                        let iref = assetRep.fullResolutionImage().takeUnretainedValue()
                        let image:UIImage = UIImage(CGImage:iref)
                    }
                }
                }, failureBlock: { error in print("NOOOOOOO") })
            
        }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        print(tabBarItem.tag)
        print(item.tag)
    }
    
    
    

    }


    







