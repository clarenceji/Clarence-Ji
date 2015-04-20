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
    
    var contentArray = [(Bool, AnyObject)]()
    
    var textViews = [NSIndexPath: UITextView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.handleTxtFile()
        self.setUpHeader(self.headerCell)
        
        tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
        tableView.estimatedRowHeight = 10.0
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
        self.navigationController?.view.insertSubview(btn_GoBack, belowSubview: self.navigationController!.navigationBar)
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
        switch self.contentArray[indexPath.row].0 {
        case true:
            // Bool is true - element in array is an image
            let cell = NSBundle.mainBundle().loadNibNamed("CJTableView2_Cell", owner: self, options: nil)[1] as! CJTableView2_ImageCell
            cell.selectionStyle = .None
            let newImage = self.contentArray[indexPath.row].1 as! UIImageView
          
            cell.image_View.addSubview(newImage)
            cell.image_View.frame = newImage.bounds
            
            if NSUserDefaults.standardUserDefaults().boolForKey("DarkMode") {
                cell.backgroundColor = .blackColor()
            }
            
            return cell
            
        case false:
            // Bool is false - element in array is not an image
            let cell = NSBundle.mainBundle().loadNibNamed("CJTableView2_Cell", owner: self, options: nil)[0] as! CJTableView2_Cell
            cell.selectionStyle = .None
            self.textViews[indexPath] = cell.label_Main
            // Configure the cell
            cell.label_Main.attributedText = self.contentArray[indexPath.row].1 as! NSAttributedString
            println(indexPath.row)
            if NSUserDefaults.standardUserDefaults().boolForKey("DarkMode") {
                cell.backgroundColor = .blackColor()
                cell.label_Main.textColor = .whiteColor()
            }
            
            return cell
        default:
            break
            
        }
        
        return UITableViewCell()
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
            generateAttrString(path)
            
            let imageView1 = CJImageView(image: UIImage(named: "Intro_1")!)
            self.contentArray.insert((true, imageView1), atIndex: 1)
            
            let imageView2 = CJImageView(image: UIImage(named: "Intro_2")!)
            self.contentArray.insert((true, imageView2), atIndex: 3)
            
        case 1:
            let path = NSBundle.mainBundle().pathForResource("Text_Education", ofType: "txt")
            generateAttrString(path)
            
            let imageView1 = CJImageView(image: UIImage(named: "Edu_1")!)
            self.contentArray.insert((true, imageView1), atIndex: 2)
            
            let imageView2 = CJImageView(image: UIImage(named: "Edu_2")!)
            self.contentArray.insert((true, imageView2), atIndex: 6)
        default:
            break
        }
    }
    
    func generateAttrString(path: String?) {
        if let content = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil) {
            
            var array = content.componentsSeparatedByString("\n¶")
            let attrStyle = NSMutableParagraphStyle()
            attrStyle.lineSpacing = 8
            attrStyle.paragraphSpacing = 12
            
            for element in array {
                var string = element
                var attributes = [
                    NSParagraphStyleAttributeName: attrStyle,
                    NSFontAttributeName: UIFont(name: "MyriadPro-Light", size: 17.0)!
                ]
                var attrString = NSMutableAttributedString(string: string, attributes: attributes)
                if string[string.startIndex] == "•" {
                    println(string)
                    string.removeAtIndex(string.startIndex)
                    attributes[NSFontAttributeName] = UIFont(name: "MyriadPro-Regular", size: 17.0)!
                    
                    let newAttrStyle = attrStyle.mutableCopy() as! NSMutableParagraphStyle
                    newAttrStyle.paragraphSpacing = 3
                    newAttrStyle.lineSpacing = 0
                    attributes[NSParagraphStyleAttributeName] = newAttrStyle
                    
                    attrString = NSMutableAttributedString(string: string, attributes: attributes)
                }
                
                
                contentArray.append((false, attrString))
            }
            
        }
    }
    
    func textViewHeightForRowAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
        var calculationView = textViews[indexPath]
        var textViewWidth = calculationView?.frame.size.width
        if calculationView?.attributedText != nil {
            calculationView = UITextView()
            calculationView!.attributedText = contentArray[indexPath.row].1 as! NSAttributedString
            textViewWidth = UIScreen.mainScreen().bounds.width
        }
        let size = calculationView!.sizeThatFits(CGSizeMake(textViewWidth!, CGFloat(FLT_MAX)))
        return size.height
    }
    

//    func resizeImage(image: UIImage) -> UIImage {
//        let screenWidth = UIScreen.mainScreen().bounds.width
//        let imageRatio = image.size.height / image.size.width
//        let imageViewHeight = screenWidth * imageRatio
//        let size = CGSizeMake(screenWidth, imageViewHeight)
//        
//        
//    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if contentArray[indexPath.row].0 {
            return contentArray[indexPath.row].1.frame.height
        } else {
            return UITableViewAutomaticDimension
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
