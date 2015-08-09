//
//  CJTableView1.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 4/15/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import UIKit

class CJTableView1: UITableViewController {

    var nightMode = NSUserDefaults.standardUserDefaults().boolForKey("DarkMode")
    let rowHeight = (UIScreen.mainScreen().bounds.height - 20) / 5
    let screenWidth = UIScreen.mainScreen().bounds.width
    var cellArray: [AnyObject?] = [nil, nil, nil, nil, nil]
    var prevDarkMode: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !NSUserDefaults.standardUserDefaults().boolForKey("AltimeterReadingReady") {
            let timer = NSTimer(timeInterval: 1.0, target: self, selector: Selector("updateTime:"), userInfo: nil, repeats: true)
            NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        }
        self.navigationController?.hidesBarsOnSwipe = false
    }
    
    override func viewDidAppear(animated: Bool) {
        navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 5
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return rowHeight + 30
        } else if indexPath.row == 4 {
            return rowHeight - 40
        }
        
        return (rowHeight + 10)
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if NSUserDefaults.standardUserDefaults().boolForKey("DarkMode") != prevDarkMode {
            cellArray = [nil, nil, nil, nil, nil]
        }
        
        if let cellInArray: AnyObject = cellArray[indexPath.row] {
            // Get stored cell from array
            return cellArray[indexPath.row] as! CJTableView1_Cell
        } else {
            // Initialize cell if cell is not stored in array
            let cell = NSBundle.mainBundle().loadNibNamed("CJTableView1_Cell", owner: self, options: nil)[0] as? CJTableView1_Cell
            var imageName = "Daytime_\(indexPath.row + 1)"
            if NSUserDefaults.standardUserDefaults().boolForKey("DarkMode") {
                imageName = "Night_\(indexPath.row + 1)"
                self.prevDarkMode = true
            } else {
                self.prevDarkMode = false
            }
        
            // Set Background Images
            cell!.backgroundView = UIImageView(image: UIImage(named: imageName))
            cell!.backgroundView?.contentMode = .ScaleAspectFill
            cell!.backgroundView?.clipsToBounds = true
            
            cell!.selectedBackgroundView = UIImageView(image: UIImage(named: imageName))
            cell!.selectedBackgroundView?.contentMode = .ScaleAspectFill
            cell!.selectedBackgroundView?.clipsToBounds = true
            
            cell!.index = indexPath.row
            cell!.tableView = self
            // Set label texts
            switch indexPath.row {
            case 0:
                cell!.label_Title.center = CGPointMake(cell!.label_Title.center.x, cell!.label_Title.center.y + 20)
                cell!.label_Title.text = "I, a Simple Guy"
            case 1:
                cell!.label_Title.text = "Never Stop Learning"
            case 2:
                cell!.label_Title.text = "Hacker's Gonna Hack"
            case 3:
                cell!.label_Title.text = "Life's Good"
            case 4:
                let cell_Barometer = NSBundle.mainBundle().loadNibNamed("CJTableView1_Cell", owner: self, options: nil)[1] as? CJTableView1_Cell_Barometer
                cell_Barometer!.view_TableViewController = self
                if NSUserDefaults.standardUserDefaults().boolForKey("DarkMode") {
                    cell_Barometer!.setDarkMode()
                }
                return cell_Barometer!
            default:
                cell!.label_Title.text = ""
            }
            
            // Store cell in array and return it
            cellArray[indexPath.row] = cell!
            return cell!
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != 4 {
            for index in 0..<5 {
                tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))?.alpha = 0
            }
            tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
        }
        
    }
    

    func updateTime(timer: NSTimer) {
        if let barometerCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 0)) as? CJTableView1_Cell_Barometer {
            barometerCell.timerTick(nil)
        }
    }
}
