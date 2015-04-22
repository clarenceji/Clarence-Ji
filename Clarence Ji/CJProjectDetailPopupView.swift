//
//  CJProjectDetailPopupView.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 4/21/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import UIKit

class CJProjectDetailPopupView: UIView, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet var scrollView_Images: UIScrollView!
    @IBOutlet var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var label_Title: UILabel!
    @IBOutlet var label_Description: UILabel!
    @IBOutlet var tableView_Details: UITableView!
    
    var prevTableVC: CJTableView2!
    
    var btn_Details: UIButton!
    var btn_Done: UIButton!
    
    var urlString: String!
    var dict_ProjectInfo: [String: AnyObject]!
    var dict_CurrentProject: [String: AnyObject]?
    
    var array_Keys: [String]?
    var array_Values: [String]?
    
    let screen = UIScreen.mainScreen().bounds
    let selfWidth = UIScreen.mainScreen().bounds.width
    let selfHeight = UIScreen.mainScreen().bounds.height
    var numberOfImages = 3
    var pageControl: UIPageControl!
    
    let darkMode = NSUserDefaults.standardUserDefaults().boolForKey("DarkMode")
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        // screen.height + selfHeight: Prepare for animation
        let selfFrame = CGRectMake(0, screen.height + selfHeight, selfWidth, selfHeight)
        self.frame = selfFrame
        
        // Blur View
        var blurEffect = UIBlurEffect(style: .Dark)
        if darkMode {
            blurEffect = UIBlurEffect(style: .Light)
        }
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.bounds
        self.backgroundColor = .clearColor()
        self.addSubview(blurView)
        self.sendSubviewToBack(blurView)
        
        // Add buttons
        self.addButtons()
        
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
        
        self.scrollView_Images.delegate = self
        self.scrollView_Images.pagingEnabled = true
        // Image takes up 1/3 of whole view
        self.scrollViewHeightConstraint.constant = selfHeight / 3
        self.layoutIfNeeded()
        
        self.tableView_Details.delegate = self
        self.tableView_Details.dataSource = self
        self.tableView_Details.estimatedRowHeight = 30.0
        self.tableView_Details.rowHeight = UITableViewAutomaticDimension
        
        
        // Read & save json file
        self.dict_ProjectInfo = jsonToDict()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var offsetLooping = 1
        var page = (scrollView.contentOffset.x - selfWidth / CGFloat(2)) / selfWidth + CGFloat(offsetLooping)
        pageControl.currentPage = Int(page) % numberOfImages
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView_Images.contentOffset.y != 0 {
            scrollView_Images.contentOffset = CGPointMake(scrollView.contentOffset.x, 0)
        }
    }
    
    override func removeFromSuperview() {
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .CurveEaseInOut, animations: {
            self.center = CGPointMake(self.center.x, self.selfHeight * 2)
            self.prevTableVC.btn_GoBack.alpha = 1.0
            self.alpha = 0
            self.superview!.transform = CGAffineTransformMakeScale(1, 1)
            self.superview!.layer.cornerRadius = 0
        }) { (complete) -> Void in
            self.prevTableVC.tableView.scrollEnabled = true
            super.removeFromSuperview()
        }
    }
    
    func addImages(fileNames: [String]) {
        self.numberOfImages = fileNames.count
        
        // Populate ScrollView with Images
        for (var i = 0; i < numberOfImages; i++) {
            var frame = CGRectMake(
                self.frame.size.width * CGFloat(i),
                0,
                self.frame.size.width,
                scrollView_Images.frame.size.height
            )
            
            let imageView = UIImageView(frame: frame)
            imageView.contentMode = .ScaleAspectFill
            imageView.image = UIImage(named: fileNames[i])!
            imageView.clipsToBounds = true
            scrollView_Images.addSubview(imageView)
        }
        
        scrollView_Images.contentSize = CGSizeMake(selfWidth * CGFloat(numberOfImages), selfHeight / 3);
        
        // Add PageControl
        pageControl = UIPageControl(frame: CGRectMake(0, scrollView_Images.frame.size.height + scrollView_Images.frame.origin.y - 20, selfWidth, 20))
        pageControl.numberOfPages = numberOfImages
        self.addSubview(pageControl)
    }
    
    func addButtons() {
        let font_Reg = UIFont(name: "MyriadPro-Regular", size: 17.0)
        let font_Light = UIFont(name: "MyriadPro-Light", size: 17.0)
        var bgColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        if darkMode {
            bgColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        }
        btn_Details = UIButton(frame: CGRectMake(0, selfHeight - 44, selfWidth / 2, 44))
        btn_Details.setTitle("More Details", forState: .Normal)
        btn_Details.titleLabel?.font = font_Reg
        btn_Details.backgroundColor = bgColor
        btn_Details.addTarget(self, action: Selector("btn_Details_Pressed:"), forControlEvents: .TouchUpInside)
        btn_Done = UIButton(frame: CGRectMake(selfWidth / 2, selfHeight - 44, selfWidth / 2, 44))
        btn_Done.setTitle("Done", forState: .Normal)
        btn_Done.titleLabel?.font = font_Light
        btn_Done.backgroundColor = bgColor
        btn_Done.addTarget(self, action: Selector("btn_Done_Pressed:"), forControlEvents: .TouchUpInside)
        self.addSubview(btn_Details)
        self.addSubview(btn_Done)
    }
    
    func btn_Done_Pressed(sender: AnyObject) {
        removeFromSuperview()
    }
    
    func btn_Details_Pressed(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: self.urlString)!)
    }
    
    func jsonToDict() -> [String: AnyObject] {
        let path = NSBundle.mainBundle().pathForResource("Project_Info", ofType: "json")
        if let data = NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe, error: nil) {
            var error: NSError?
            let json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &error) as! [String: AnyObject]
            return json
        }
        
        return [String: AnyObject]()
    }
    
    func addContents(title: String) {
        self.dict_CurrentProject = dict_ProjectInfo[title] as? [String: AnyObject]
        label_Title.text = title
        
        if let currentDict = self.dict_CurrentProject {
            // 1 - Images
            addImages(currentDict["image"] as! [String])
            // 2 - URL
            self.urlString = currentDict["url"] as! String
            // 3 - Description
            var string = currentDict["description"] as? String
            let attrStyle = NSMutableParagraphStyle()
            attrStyle.lineSpacing = 7
            var attributes = [
                NSParagraphStyleAttributeName: attrStyle
            ]
            var attrString = NSMutableAttributedString(string: string!, attributes: attributes)
            self.label_Description.attributedText = attrString
            self.label_Description.textAlignment = .Center
            // 4 - Details
            array_Keys = [String]()
            array_Values = [String]()
            for (key, value) in (currentDict["details"] as! [String: String]) {
                array_Keys?.append(key)
                array_Values?.append(value)
            }
        }
        
        self.tableView_Details.reloadData()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if array_Keys != nil {
            return array_Keys!.count
        }
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = NSBundle.mainBundle().loadNibNamed("CJProjectDetailPopupView", owner: self, options: nil)[1] as! CJProjectDetailPopupView_Cell
        cell.selectionStyle = .None
        
        let attrStyle = NSMutableParagraphStyle()
        attrStyle.lineSpacing = 7
        var attributes = [
            NSParagraphStyleAttributeName: attrStyle
        ]
        
        if array_Keys != nil && array_Values != nil {
            var attrString_Key = NSMutableAttributedString(string: array_Keys![indexPath.row], attributes: attributes)
            var attrString_Value = NSMutableAttributedString(string: array_Values![indexPath.row], attributes: attributes)
            
            cell.label_Key.attributedText = attrString_Key
            cell.label_Value.attributedText = attrString_Value
            
            cell.label_Key.textAlignment = .Right
            
            cell.label_Key_ConstraintWidth.constant = self.frame.size.width * 0.32
            cell.layoutIfNeeded()
        }
        
        return cell
    }
    
}
