

import UIKit
import Parse
import CoreData
import AssetsLibrary

class NotificationController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    var appDel = AppDelegate()
    var library:ALAssetsLibrary = ALAssetsLibrary()
    let numberRowOfTableView_1 = 0

    @IBOutlet weak var imageShow: UIImageView!
    @IBOutlet weak var viewShowImage: UIView!
    var indexSelect:Int = 0
    var indexSelectFile:Int = 0
    @IBOutlet weak var viewActivity: UIView!
    @IBOutlet weak var activityIndi: UIActivityIndicatorView!
    var DetectType = [String]()
    var DetectDate = [String]()
    var DetectTime = [String]()
    var DetectImage0 = [UIImage]()
    var DetectImage1 = [UIImage]()
    var DetectImage2 = [UIImage]()
    

    
    @IBOutlet var tableView_1: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var currentInstallation = PFInstallation.currentInstallation()
        if(currentInstallation.badge != 0){
            currentInstallation.badge = 0
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pullNotification:", name: "pullID", object: nil)
     
        self.tableView_1.delegate = self
        self.tableView_1.dataSource = self
    

        }
    func pullNotification(notification:NSNotification){
            self.DetectType.removeAll()
            self.DetectDate.removeAll()
            self.DetectTime.removeAll()
            self.DetectImage0.removeAll()
            self.DetectImage1.removeAll()
            self.DetectImage2.removeAll()
            self.viewActivity.hidden = false
            self.activityIndi.hidden = false
            self.activityIndi.startAnimating()
            self.loadImages()
       

        
        
    }
 

    func loadImages() {
        
        let query = PFQuery(className: "Notification")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error:NSError?) -> Void in
          if(error == nil){
            if objects!.count > 0{
            for object in objects! {
                
            

                    let decodedData0 = NSData(base64EncodedString: object["fileData1"] as! String, options: NSDataBase64DecodingOptions(rawValue: 0))
                    let decodedData1 = NSData(base64EncodedString: object["fileData2"] as! String, options: NSDataBase64DecodingOptions(rawValue: 0))
                    let decodedData2 = NSData(base64EncodedString: object["fileData3"] as! String, options: NSDataBase64DecodingOptions(rawValue: 0))
                    self.DetectImage0.append(UIImage(data: decodedData0!)!)
                    self.DetectImage1.append(UIImage(data: decodedData1!)!)
                    self.DetectImage2.append(UIImage(data: decodedData2!)!)
                    
                     //var dateDetect = str[0]+str[1]
                   // print(str)
                    
                    
                    
        
                    var timeDetect = object["fileName"] as! String
                    var str = timeDetect.componentsSeparatedByString("-")
                    
                     var typeDetect = object["detectType"] as! String
                    self.DetectTime.append(str[0])
                    self.DetectDate.append(str[1])
                    self.DetectType.append(typeDetect)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                        self.tableView_1.reloadData()
                    print ("reload")
                })
                
                }
            }else{
                print("object not found")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.activityIndi.stopAnimating()
                    self.activityIndi.hidden = true
                    self.viewActivity.hidden = true
                    self.tableView_1.reloadData()
        })
            }
            
        } else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.activityIndi.stopAnimating()
                self.activityIndi.hidden = true
                self.viewActivity.hidden = true
                self.tableView_1.reloadData()
            })
            }
        }
        
    }

    
    override func viewDidAppear(animated: Bool) {
            self.viewActivity.hidden = true
            self.activityIndi.hidden = true
            NSNotificationCenter.defaultCenter().postNotificationName("pullID", object: nil)
            self.imageShow.hidden = true
            self.viewShowImage.hidden = true
   
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return self.DetectType.count
    }
        
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
    
        
        
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "REMOTE NOTIFICATION"
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
      // cell.backgroundColor = UIColor.clearColor()
  
      //  tableView.backgroundColor = UIColor.clearColor()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell:classTableViewCell_1 = tableView.dequeueReusableCellWithIdentifier("HumanCell") as! classTableViewCell_1
            cell.imageView1.image = self.DetectImage0[indexPath.row]
            cell.imageView2.image = self.DetectImage1[indexPath.row]
            cell.imageView3.image = self.DetectImage2[indexPath.row]
            cell.timeOfFaceDetect.text = self.DetectTime[indexPath.row]
            cell.dateOfFaceDetect.text = self.DetectDate[indexPath.row]
            //cell.video.addTarget(self, action: "humanVideo", forControlEvents: .TouchUpInside)
            //
            cell.btnImage0.tag = indexPath.row
                cell.tapBlockImage0 = {
                    self.image0(indexPath.row)
                }
            cell.btnImage1.tag = indexPath.row
                cell.tapBlockImage1 = {
                    self.image1(indexPath.row)
                }
        
            cell.btnImage2.tag = indexPath.row
                cell.tapBlockImage2 = {
                    self.image2(indexPath.row)
                }
        
        
            cell.video.tag = indexPath.row
                cell.tapBlock = {
                   self.humanVideo(indexPath.row)
                }

            if self.DetectType[indexPath.row] == "Human"{
                cell.imageViewType.image = UIImage(named: "money.png")
            }else if self.DetectType[indexPath.row] == "Fire" {
                cell.imageViewType.image = UIImage(named: "home.png")
            }else{
                 cell.imageViewType.image = UIImage(named: "160322030017.png")
                
            }
            //cell.backgroundColor = UIColor(red: 0, green: 245, blue: 249, alpha: 1)
        print("stop3")
        
            self.activityIndi.stopAnimating()
            self.activityIndi.hidden = true
            self.viewActivity.hidden = true

            return cell

        
        
        
    }
    
    func image0(index_path:Int){
        self.indexSelectFile = 0
        self.indexSelect = index_path
            print("check1")
        self.tabBarController?.tabBar.hidden = true
        self.viewShowImage.hidden = false
        self.imageShow.hidden = false
        self.imageShow.image = self.DetectImage0[index_path]
        
    }
    func image1(index_path:Int){
        self.indexSelectFile = 1
        self.indexSelect = index_path
        print("check2")
        self.viewShowImage.hidden = false
        self.imageShow.hidden = false
        self.imageShow.image = self.DetectImage1[index_path]
        
    }
    func image2(index_path:Int){
        self.indexSelectFile = 2
        self.indexSelect = index_path
        print("check3")
        self.viewShowImage.hidden = false
        self.imageShow.hidden = false
        self.imageShow.image = self.DetectImage2[index_path]
        
    }    
    func humanVideo(index_path:Int){
        singleton.sharedInstance.setFileStreamRecordV(self.DetectTime[index_path]+"-"+self.DetectDate[index_path])
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("recordVideo") as! StreamVideoRecordController
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
         return true
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
    
        let delete = UITableViewRowAction(style: .Destructive, title: "Delete") { (action:UITableViewRowAction?, indexPath:NSIndexPath?) -> Void in
            self.viewActivity.hidden = false
            self.activityIndi.hidden = false
            self.activityIndi.startAnimating()
            print(self.DetectTime[(indexPath?.row)!])
            let query = PFQuery(className: "Notification")
            query.whereKey("fileName", equalTo: self.DetectTime[(indexPath?.row)!]+"-"+self.DetectDate[(indexPath?.row)!])
            query.findObjectsInBackgroundWithBlock({ (objects:[PFObject]?, error:NSError?) -> Void in
                if objects != nil{
                    for object in objects! {
                        object.deleteInBackgroundWithBlock({ (result:Bool, error:NSError?) -> Void in
                            print(result)
                            if result == true && error == nil{
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.appDel.publishStreamRecord("Delete,"+self.DetectTime[(indexPath?.row)!])
                                    self.DetectType.removeAtIndex((indexPath?.row)!)
                                    self.DetectDate.removeAtIndex((indexPath?.row)!)
                                    self.DetectTime.removeAtIndex((indexPath?.row)!)
                                    self.DetectImage0.removeAtIndex((indexPath?.row)!)
                                    self.DetectImage1.removeAtIndex((indexPath?.row)!)
                                    self.DetectImage2.removeAtIndex((indexPath?.row)!)
                                    self.tableView_1.reloadData()
                                    self.activityIndi.stopAnimating()
                                    self.activityIndi.hidden = true
                                    self.viewActivity.hidden = true
                                    
                                    print ("reload")
                                })
                                
                            }else{
                            
                                print("error delete")
                            }
                        })

                        
                    }
                }else{
                    print("not found Data")
                }
                
            })
  
            
            
        
        }
        delete.backgroundColor = UIColor.redColor()

            // delete item at indexPath
        
    
        return [delete]
      
    
    }
    
    
    
    
    
    
    @IBOutlet weak var btnCloseShowImage: UIButton!
    @IBAction func saveImage(sender: AnyObject) {
        
        print(self.indexSelectFile)
        print(self.indexSelect)
        if self.indexSelectFile == 0{
            saveImageToAlbum(self.DetectImage0[self.indexSelect])
        }
        else if self.indexSelectFile == 1{
            saveImageToAlbum(self.DetectImage1[self.indexSelect])
        }else{
            saveImageToAlbum(self.DetectImage2[self.indexSelect])
        }
    }
    @IBAction func btnCloseImageShowAc(sender: AnyObject) {
        self.viewShowImage.hidden = true
        self.tabBarController?.tabBar.hidden = false


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
        let alertView = UIAlertController(title: "", message: "The photo has been saved.", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)


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
    
}



