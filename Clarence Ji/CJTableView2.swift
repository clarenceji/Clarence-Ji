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
    
    var clickableCells = [NSIndexPath]()
    var renderedCells = [UITableViewCell]()
    
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
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
    
    let btn_GoBack = CJBackButton(frame: CGRectMake(16, 28, 50, 20))
    override func viewWillAppear(animated: Bool) {
        setUpHeader(self.headerCell)
        
        btn_GoBack.addAction(self)
        self.navigationController?.view.insertSubview(btn_GoBack, belowSubview: self.navigationController!.navigationBar)
        
        navigationController!.setNavigationBarHidden(true, animated: true)
        self.title = (headerCell as! CJTableView1_Cell).label_Title.text
    }
    
    override func viewWillDisappear(animated: Bool) {
        btn_GoBack.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset
        let imageHeight = self.headerCell.bounds.height
        
        if imageHeight - offset.y < 80 && navigationController?.navigationBarHidden == true {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        } else if imageHeight - offset.y >= 80 && navigationController?.navigationBarHidden == false {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let imageHeight = self.headerCell.bounds.height
        
        if imageHeight - offset.y >= 80 && navigationController?.navigationBarHidden == false {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return contentArray.count
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.setSelected(false, animated: true)
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if renderedCells.count > indexPath.row {
            return renderedCells[indexPath.row]
        } else {
            switch self.contentArray[indexPath.row].0 {
            case true:
                // Bool is true - element in array is an image
                let cell = NSBundle.mainBundle().loadNibNamed("CJTableView2_Cell", owner: self, options: nil)[1] as! CJTableView2_ImageCell
                cell.selectionStyle = .None
                cell.userInteractionEnabled = false
                let newImage = self.contentArray[indexPath.row].1 as! UIImageView
                
                cell.image_View.addSubview(newImage)
                cell.image_View.frame = newImage.bounds
                
                if NSUserDefaults.standardUserDefaults().boolForKey("DarkMode") {
                    cell.backgroundColor = .blackColor()
                }
                
                renderedCells.append(cell)
                
                return cell
                
            case false:
                // Bool is false - element in array is not an image
                let cell = NSBundle.mainBundle().loadNibNamed("CJTableView2_Cell", owner: self, options: nil)[0] as! CJTableView2_Cell
                cell.selectionStyle = .None
                cell.userInteractionEnabled = false
                self.textViews[indexPath] = cell.label_Main
                // Configure the cell
                let attrString = self.contentArray[indexPath.row].1 as! NSMutableAttributedString
                if attrString.string[attrString.string.startIndex] == "∞" {
                    attrString.deleteCharactersInRange(NSMakeRange(0, 1))
                    clickableCells.append(indexPath)
                }
                for iP in clickableCells {
                    if iP == indexPath {
                        cell.selectionStyle = .Default
                        cell.accessoryType = .DisclosureIndicator
                        cell.label_Main.userInteractionEnabled = false
                        cell.userInteractionEnabled = true
                    }
                }
                cell.label_Main.attributedText = attrString
                if NSUserDefaults.standardUserDefaults().boolForKey("DarkMode") {
                    cell.backgroundColor = .blackColor()
                    cell.label_Main.textColor = .whiteColor()
                }
                
                renderedCells.append(cell)
                
                return cell
            default:
                break
                
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CJTableView2_Cell
        cell.setSelected(false, animated: false)
        self.presentHoverView(cell.label_Main.text)
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
            
        case 2:
            let path = NSBundle.mainBundle().pathForResource("Text_Hacker", ofType: "txt")
            generateAttrString(path)
            
        case 3:
            let path = NSBundle.mainBundle().pathForResource("Text_Life", ofType: "txt")
            generateAttrString(path)
            
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
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if contentArray[indexPath.row].0 {
            return contentArray[indexPath.row].1.frame.height
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func presentHoverView(title: String) {
        let hoverView = NSBundle.mainBundle().loadNibNamed("CJProjectDetailPopupView", owner: self, options: nil)[0] as! CJProjectDetailPopupView
        hoverView.prevTableVC = self
        hoverView.addContents(title)
        self.navigationController!.view.addSubview(hoverView)
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .CurveEaseInOut, animations: {
            self.navigationController!.view.transform = CGAffineTransformMakeScale(0.9, 0.9)
            self.navigationController!.view.layer.cornerRadius = 8.0
            self.navigationController!.view.clipsToBounds = true
            
            hoverView.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, UIScreen.mainScreen().bounds.height / 2)
            self.btn_GoBack.alpha = 0
            }) { (complete) -> Void in
                self.tableView.scrollEnabled = false
        }
    }


}
