//
//  StreamVideoRecordController.swift
//  vlckitSwiftSample
//
//  Created by Macintosh on 3/14/2559 BE.
//  Copyright © 2559 Mark Knapp. All rights reserved.
//

import UIKit
import PubNub
import Parse
import Bolts
import ReplayKit
import AssetsLibrary
import AVFoundation
class StreamVideoRecordController: UIViewController,RPPreviewViewControllerDelegate {
    var library:ALAssetsLibrary = ALAssetsLibrary()
    var audioPlayer = AVAudioPlayer()
    @IBOutlet weak var streamFileLabel: UILabel!

    @IBOutlet weak var stopRecord: UIButton!
     var fileName = ""
    
    @IBOutlet weak var activityStream: UIActivityIndicatorView!
    var appDel = AppDelegate()
    var movieView: UIView!
    var mediaPlayer = VLCMediaPlayer()
    var fileNameRecord = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fileName = singleton.sharedInstance.getFileStreamRecordV()
        self.streamFileLabel.text = self.fileName
        self.fileNameRecord  = self.fileName.componentsSeparatedByString("-")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "update:", name: "updateRecordID", object: nil)
        print("ok")
        self.movieView = UIView()
        
        self.movieView.backgroundColor = UIColor.blackColor()
        //Add tap gesture to movieView for play/pause
        self.movieView.frame = CGRectMake(157, 201, 713, 401)
        let gesture = UITapGestureRecognizer(target: self, action: "movieViewTapped:")
        
        //Add movieView to view controller
        self.view.addSubview(self.movieView)
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        self.movieView.addSubview(self.activityStream)
        self.activityStream.hidden = false
        self.activityStream.startAnimating()
        //Playing RTSP from internet
        let url = NSURL(string: "https://project-raspisecurityhome.pagekite.me")
        let media = VLCMedia(URL: url)
        mediaPlayer.setMedia(media)
        mediaPlayer.setDelegate(self)
        mediaPlayer.drawable = self.movieView
        print(self.fileNameRecord[0])
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            dispatch_async(dispatch_get_main_queue()) {
                self.appDel.publishStreamRecord("start,"+self.fileNameRecord[0])

            }
        }
        
    }
    
    override func viewDidDisappear(animated: Bool) {
    }
    
    


        
        
        func update(notification:NSNotification){
            var status:Bool = singleton.sharedInstance.getstreamReccord()
            if status == true{
                print("play")
                mediaPlayer.play()
                self.activityStream.stopAnimating()
                self.activityStream.hidden = true
            }else if status == false{
                print("stop")
                mediaPlayer.stop()

            }
        }
    

    @IBOutlet weak var captureBtn: UIButton!
    
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
        let recorder = RPScreenRecorder.sharedRecorder()
        self.movieView.frame = CGRectMake(157, 201, 713, 401)
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
    

    @IBAction func back(sender: AnyObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            dispatch_async(dispatch_get_main_queue()) {
                self.appDel.publishStreamRecord("stop,")
            }
        }


        self.dismissViewControllerAnimated(true, completion: nil)
        
        var destinationVC : UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Notification") as! NotificationController
        destinationVC.tabBarController?.tabBar.hidden = false
    }


}
