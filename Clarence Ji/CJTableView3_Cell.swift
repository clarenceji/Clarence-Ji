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
    
    let nightMode = UserDefaults.standard.bool(forKey: "DarkMode")
    
    let strings_Title = [
        "Why air pressure? (iPhone 6 & 6p)",
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
        switch_DarkMode.isHidden = true
        selectionStyle = .none
        // Set label colors
        setDarkModeLabels(UserDefaults.standard.bool(forKey: "DarkMode"))
    }
    
    func setLabels(_ cellAtRow: Int) {
        label_Title.text = strings_Title[cellAtRow]
        
        let attrString = NSMutableAttributedString(string: strings_Text[cellAtRow])
        let attrStyle = NSMutableParagraphStyle()
        attrStyle.lineSpacing = 8
        attrString.addAttribute(NSParagraphStyleAttributeName, value: attrStyle, range: NSMakeRange(0, strings_Text[cellAtRow].characters.count))
        label_Text.attributedText = attrString
        
        
        // Show dark mode switch
        if cellAtRow == 1 {
            if nightMode {
                self.switch_DarkMode.isOn = true
            } else {
                self.switch_DarkMode.isOn = false
            }
            self.switch_DarkMode.isHidden = false
        }
    }

    @IBAction func switch_DarkMode_Triggered(_ sender: AnyObject) {
        setDarkModeManually(switch_DarkMode.isOn)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func getCellHeight() -> CGFloat {
        let height = 20 + label_Text.bounds.height + label_Title.bounds.height
        return height
    }
    
    func setDarkModeManually(_ darkMode: Bool) {
        UserDefaults.standard.set(darkMode, forKey: "DarkMode")
        setDarkModeLabels(darkMode)
        if darkMode {
            DispatchQueue.main.async(execute: {
                CJNavView1.applyNavigationBarStyleDark(self.tableView)
            })
        }
    }
    
    func setDarkModeLabels(_ darkMode: Bool?) {
        DispatchQueue.main.async(execute: {
            if darkMode == false || darkMode == nil {
                CJNavView1.applyNavigationBarStyleLight(self.tableView)
                self.label_Text.textColor = UIColor.black
                self.label_Title.textColor = UIColor.black
            } else if darkMode == true {
                CJNavView1.applyNavigationBarStyleDark(self.tableView)
                self.label_Title.textColor = UIColor.gray
                self.label_Text.textColor = UIColor.white
            }
        })
        if tableView != nil {
            tableView.tableView.reloadData()
        }
    }
    
}
