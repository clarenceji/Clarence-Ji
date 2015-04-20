//
//  CJTableView1_Cell_Barometer.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 4/16/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import UIKit

class CJTableView1_Cell_Barometer: UITableViewCell {

    var view_TableViewController: CJTableView1!
    
    @IBOutlet var label_Title: UILabel!
    @IBOutlet var label_Reading: UILabel!
    @IBOutlet var btn_Info: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if NSUserDefaults.standardUserDefaults().boolForKey("AltimeterReadingReady") {
            let pressure = NSUserDefaults.standardUserDefaults().floatForKey("AltimeterReading")
            self.label_Reading.text = "\(pressure) hPa"
        } else {
            timerTick(nil)
            label_Title.text = "Your Local Time"
            let timer = NSTimer(timeInterval: 1.0, target: self, selector: Selector("timerTick:"), userInfo: nil, repeats: true)
            NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        }
        self.selectionStyle = .None
        self.separatorInset = UIEdgeInsetsMake(0, 1200, 0, 0)
    }
    
    let dateFormatter = NSDateFormatter()
    
    func timerTick(timer: NSTimer?) {
        println("timerTick!")
        let now = NSDate()
        dateFormatter.dateFormat = "HH:mm:ss"
        dispatch_async(dispatch_get_main_queue(), {
            self.label_Reading.text = self.dateFormatter.stringFromDate(now)
        })
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDarkMode() {
        label_Reading.textColor = UIColor.whiteColor()
        label_Title.textColor = UIColor.whiteColor()
        backgroundColor = UIColor.blackColor()
        btn_Info.tintColor = UIColor.whiteColor()
    }
    
    @IBAction func btn_Info_Clicked(sender: AnyObject) {
        let view_Info = view_TableViewController.storyboard!.instantiateViewControllerWithIdentifier("CJTableView3") as! UITableViewController
        view_TableViewController.navigationController!.pushViewController(view_Info, animated: true)
    }

}
