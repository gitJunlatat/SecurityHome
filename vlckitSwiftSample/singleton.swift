//
//  singleton.swift
//  vlckitSwiftSample
//
//  Created by Macintosh on 3/12/2559 BE.
//  Copyright © 2559 Mark Knapp. All rights reserved.
//

import UIKit

class singleton: NSObject {
        static let sharedInstance = singleton()
        
    var userkey:String = "UxT13X98J2ab"
    var userName:String = ""
    var userLockBy:String = ""
    var humanDetectStatus:Bool = false
    var fireDetectStatus:Bool = false
    var gasDetectStatus:Bool = false
    var smokeDetectStatus:Bool = false
    var streamStatus:Bool = false
    var servoLockStatus:Bool = false
    var servoAngleX:Int = 0
    var servoAngleY:Int = 0
    var data = [String]()
    var streamRecord:Bool = false
    
    
    var fileStreamRecord:String = ""
    
    
    
    private override init() {
  
        }
    func setFileStreamRecordV(_file:String){
        self.fileStreamRecord = _file
    }
    
    func getFileStreamRecordV()->String{
        return self.fileStreamRecord
    }
    
    
    func getstreamReccord() -> Bool{
        return self.streamRecord
    }
    func setstreamRecord(_streamRecord:Bool){
        self.streamRecord = _streamRecord
    }
    
    
    // userKey
    func getUserKey()->String {
            return self.userkey
        }
    func setUserKey(_userKey:String){
        self.userkey = _userKey
    }
    
    
    
    // userNameUsed
    func getUserName()->String {
        return self.userName
    }
    func SetUserName(_userName:String){
        self.userName = _userName
    }
    
    
    
    // userLockName
    func setLockBy(_lockBy:String){
        self.userLockBy = _lockBy
    }
    func getLockBy()->String{
        return self.userLockBy
    }
    
    
    
    //servo lock status
    func setServoStatus(_status:Bool){
        self.servoLockStatus = _status
    }
    func getServoStatus()->Bool{
        return self.servoLockStatus
    }
    
    
    
    // stream status
    func setVidStreamStatus(_status:Bool){
        self.streamStatus = _status
    }
    func getVidStreamStatus()->Bool{
        return self.streamStatus
    }
    
    
    
    // human detect
    func setHumanDetect(_status:Bool){
        self.humanDetectStatus =  _status
    }
    func getHumanDetect()->Bool{
        return self.humanDetectStatus
    }
    
    
    
    //fire detect
    func setFireDetect(_status:Bool){
        self.fireDetectStatus = _status
    }
    func getFireDetect()->Bool{
        return self.fireDetectStatus
    }
    
    
    
    
    //smoke Detect
    func setSmokeDetect(_status:Bool){
        self.smokeDetectStatus = _status
    }
    func getSmokeDetect()->Bool{
        return self.smokeDetectStatus
    }
    
    
    
    
    //gas detect
    func setGasDetect(_status:Bool){
        self.gasDetectStatus = _status
    }
    func getGasDetect()->Bool{
        return self.gasDetectStatus
    }
    
    
    
    //servoAngle
    func setAngleX(_x:Int){
        self.servoAngleX = _x
    }
    
    func setAngleY(_y:Int){
        self.servoAngleY = _y
    }
    
    func getAngleX()->Int{
        return self.servoAngleX
    }
    func getAngleY()->Int{
        return self.servoAngleY
    }
    
    
    
    

}
