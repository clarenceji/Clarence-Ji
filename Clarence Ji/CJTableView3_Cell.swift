//
//  CJTableView3_Cell.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 4/16/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import UIKit
import MessageUI

class CJTableView3_Cell: UITableViewCell, MFMailComposeViewControllerDelegate {

    @IBOutlet var label_Title: UILabel!
    @IBOutlet var label_Text: UILabel!
    @IBOutlet var switch_DarkMode: UISwitch!
    
    var tableView: CJTableView3!
    
    let nightMode = NSUserDefaults.standardUserDefaults().boolForKey("DarkMode")
    
    let strings_Title = [
        "Why showing the air pressure? (iPhone 6 & 6p)",
        "Dark Mode",
        "Contact me by Email",
        "Personal Website"
    ]
    
    let strings_Text = [
        "Air pressure and weather conditions are linked, and you can see different scenaries as the weather changes. This is greatly reflected by this app, which has two modes, the normal and the dark mode. When you cannot see the sun,  it will automatically switched to dark mode, showing you another set of gorgeous photos taken by myself. You can also switch between the two modes manually. The iPhone that doesn't have a barometer will show current time instead.",
        "Turn on to use dark mode.",
        "clarence@clarenceji.net",
        "Clarenceji.net"
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        switch_DarkMode.hidden = true
        selectionStyle = .None
        // Set label colors
        setDarkModeLabels(NSUserDefaults.standardUserDefaults().boolForKey("DarkMode"))
    }
    
    func setLabels(cellAtRow: Int) {
        label_Title.text = strings_Title[cellAtRow]
        
        let attrString = NSMutableAttributedString(string: strings_Text[cellAtRow])
        let attrStyle = NSMutableParagraphStyle()
        attrStyle.lineSpacing = 8
        attrString.addAttribute(NSParagraphStyleAttributeName, value: attrStyle, range: NSMakeRange(0, count(strings_Text[cellAtRow])))
        label_Text.attributedText = attrString
        
        
        // Show dark mode switch
        if cellAtRow == 1 {
            if nightMode {
                self.switch_DarkMode.on = true
            } else {
                self.switch_DarkMode.on = false
            }
            self.switch_DarkMode.hidden = false
        }
    }

    @IBAction func switch_DarkMode_Triggered(sender: AnyObject) {
        println("switched to \(switch_DarkMode.on)")
        setDarkModeManually(switch_DarkMode.on)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getCellHeight() -> CGFloat {
        let height = 20 + label_Text.bounds.height + label_Title.bounds.height
        return height
    }
    
    func setDarkModeManually(darkMode: Bool) {
        NSUserDefaults.standardUserDefaults().setBool(darkMode, forKey: "DarkMode")
        setDarkModeLabels(darkMode)
        if darkMode {
            dispatch_async(dispatch_get_main_queue(), {
                CJNavView1.applyNavigationBarStyleDark(self.tableView)
            })
        }
    }
    
    func setDarkModeLabels(darkMode: Bool?) {
        dispatch_async(dispatch_get_main_queue(), {
            if darkMode == false || darkMode == nil {
                CJNavView1.applyNavigationBarStyleLight(self.tableView)
                self.label_Text.textColor = UIColor.blackColor()
                self.label_Title.textColor = UIColor.blackColor()
            } else if darkMode == true {
                CJNavView1.applyNavigationBarStyleDark(self.tableView)
                self.label_Title.textColor = UIColor.grayColor()
                self.label_Text.textColor = UIColor.whiteColor()
            }
        })
        if tableView != nil {
            println("tableView reloaded")
            tableView.tableView.reloadData()
        }
    }
    
}
