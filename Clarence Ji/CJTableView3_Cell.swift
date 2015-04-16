//
//  CJTableView3_Cell.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 4/16/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import UIKit

class CJTableView3_Cell: UITableViewCell {

    @IBOutlet var label_Title: UILabel!
    @IBOutlet var label_Text: UILabel!
    @IBOutlet var switch_DarkMode: UISwitch!
    
    let nightMode = NSUserDefaults.standardUserDefaults().boolForKey("DarkMode")
    
    let strings_Title = [
        "Why showing the air pressure?",
        "Dark Mode",
        "Contact by Email",
        "Personal Website"
    ]
    
    let strings_Text = [
        "The app itself can be greatly affected by air pressure. There are two modes, normal and dark mode. When it is going to or is about to rain, it will automatically switched to dark mode, showing you more gorgeous photos taken by myself. I hope you don't feel sad or annoyed during the bad weather. \nYou can also switch between the two modes manually.",
        "Turn on to use dark mode.",
        "clarence@clarenceji.net",
        "Clarenceji.net"
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        switch_DarkMode.hidden = true
        selectionStyle = .None
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
    }
    
}
