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
        if UserDefaults.standard.bool(forKey: "AltimeterReadingReady") {
            let pressure = UserDefaults.standard.float(forKey: "AltimeterReading")
            self.label_Reading.text = "\(pressure) hPa"
        } else {
            timerTick(nil)
            label_Title.text = "Your Local Time"
        }
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsetsMake(0, 1200, 0, 0)
    }
    
    let dateFormatter = DateFormatter()
    
    func timerTick(_ timer: Timer?) {
        let now = Date()
        dateFormatter.dateFormat = "HH:mm:ss"
        DispatchQueue.main.async(execute: {
            self.label_Reading.text = self.dateFormatter.string(from: now)
        })
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDarkMode() {
        label_Reading.textColor = UIColor.white
        label_Title.textColor = UIColor.white
        backgroundColor = UIColor.black
        btn_Info.tintColor = UIColor.white
    }
    
    @IBAction func btn_Info_Clicked(_ sender: AnyObject) {
        let view_Info = view_TableViewController.storyboard!.instantiateViewController(withIdentifier: "CJTableView3") as! UITableViewController
        view_TableViewController.navigationController!.pushViewController(view_Info, animated: true)
    }

}
