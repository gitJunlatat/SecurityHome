//
//  tableViewFile.swift
//  vlckitSwiftSample
//
//  Created by Macintosh on 2/21/2559 BE.
//  Copyright © 2559 Mark Knapp. All rights reserved.
//

import UIKit




class classTableViewCell_1:UITableViewCell{
    @IBOutlet weak var btnImage0: UIButton!
    @IBOutlet weak var btnImage1: UIButton!
    @IBOutlet weak var btnImage2: UIButton!

    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var imageView3: UIImageView!
    @IBOutlet var dateOfFaceDetect: UILabel!
    @IBOutlet var timeOfFaceDetect: UILabel!
    @IBOutlet weak var video: UIButton!
    
    @IBOutlet weak var imageViewType: UIImageView!
    var tapBlock: dispatch_block_t?
    var tapBlockImage0: dispatch_block_t?
    var tapBlockImage1: dispatch_block_t?
    var tapBlockImage2: dispatch_block_t?
    

    
    @IBAction func didTouchButton(sender: AnyObject) {
        if let tapBlock = self.tapBlock {
            tapBlock()
        }
    }
    @IBAction func didtouchImage0(sender: AnyObject) {
        if let tapBlockImage0 = self.tapBlockImage0 {
            tapBlockImage0()
    }
}
    @IBAction func didtouchImage1(sender: AnyObject) {
        if let tapBlockImage1 = self.tapBlockImage1 {
            tapBlockImage1()
        }
    }
    @IBAction func didtouchImage2(sender: AnyObject) {
        if let tapBlockImage2 = self.tapBlockImage2 {
            tapBlockImage2()
        }
    }
}








