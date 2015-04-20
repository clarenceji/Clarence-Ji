//
//  CJTableView2.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 4/18/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import UIKit

class CJTableView2: UITableViewController {

    @IBOutlet var view_Header: UIView!
    
    var headerCell: UITableViewCell!
    var indexFromPrevView: Int!
    
    var contentArray = [NSAttributedString]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.handleTxtFile()
        self.setUpHeader(self.headerCell)
        
        tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.separatorStyle = .None
        
        if NSUserDefaults.standardUserDefaults().boolForKey("DarkMode") {
            CJNavView1.applyNavigationBarStyleDark(self)
            self.view_Header.backgroundColor = UIColor.blackColor()
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func headerCell(cell: UITableViewCell) {
        self.headerCell = cell
    }
    
    func setUpHeader(tableCell: UITableViewCell) {
        tableCell.frame.origin = CGPointMake(0, 0)
        self.view_Header.frame = tableCell.bounds
        self.view_Header.addSubview(tableCell)
        self.view_Header.userInteractionEnabled = false
    }
    
    func btn_GoBack_Clicked(btn: UIButton) {
        println("clicked")
    }
    
    let btn_GoBack = CJBackButton(frame: CGRectMake(16, 28, 50, 20))
    override func viewWillAppear(animated: Bool) {
        setUpHeader(self.headerCell)
        
        btn_GoBack.addAction(self)
        self.navigationController?.view.addSubview(btn_GoBack)
    }
    
    override func viewWillDisappear(animated: Bool) {
        btn_GoBack.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return contentArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = NSBundle.mainBundle().loadNibNamed("CJTableView2_Cell", owner: self, options: nil)[0] as! CJTableView2_Cell
        cell.selectionStyle = .None
        
        // Configure the cell
        cell.label_Main.attributedText = self.contentArray[indexPath.row]
        println(indexPath.row)
        if NSUserDefaults.standardUserDefaults().boolForKey("DarkMode") {
            cell.backgroundColor = .blackColor()
            cell.label_Main.textColor = .whiteColor()
        }

        return cell
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        var y = offset.y + bounds.size.height - inset.bottom
        
        let image_Height = self.view_Header.bounds.height
        if image_Height - offset.y <= 75 {
            self.title = (headerCell as! CJTableView1_Cell).label_Title.text
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        } else if image_Height - offset.y > 80 {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    func handleTxtFile() {
        switch indexFromPrevView {
        case 0:
            let path = NSBundle.mainBundle().pathForResource("Text_Intro", ofType: "txt")
            if let content = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil) {
                
                var array = content.componentsSeparatedByString("\n")
                println(array[1])
                let attrStyle = NSMutableParagraphStyle()
                attrStyle.lineSpacing = 8
                
                for element in array {
                    let element = "\(element) \n"
                    let attrString = NSMutableAttributedString(string: element)
                    attrString.addAttribute(NSParagraphStyleAttributeName, value: attrStyle, range: NSMakeRange(0, count(element)))
                    contentArray.append(attrString)
                }
                
            }
        default:
            break
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
