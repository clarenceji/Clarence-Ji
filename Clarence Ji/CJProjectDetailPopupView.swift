//
//  CJProjectDetailPopupView.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 4/21/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import UIKit

class CJProjectDetailPopupView: UIView, UIScrollViewDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var label_Title: UILabel!
    @IBOutlet var label_Description: UILabel!
    @IBOutlet var label_Keys: UILabel!
    @IBOutlet var label_Values: UILabel!
    
    var btn_Details: UIButton!
    var btn_Done: UIButton!
    
    var urlString: String!
    var dict_ProjectInfo: [String: AnyObject]!
    var dict_CurrentProject: [String: AnyObject]!
    
    let screen = UIScreen.mainScreen().bounds
    let selfWidth = UIScreen.mainScreen().bounds.width * 0.9
    let selfHeight = UIScreen.mainScreen().bounds.height * 0.85
    var numberOfImages = 3
    var pageControl: UIPageControl!
    
    let darkMode = NSUserDefaults.standardUserDefaults().boolForKey("DarkMode")
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        println("init run")
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
        
        self.scrollView.delegate = self
        self.scrollView.pagingEnabled = true
        // Image takes up 1/3 of whole view
        self.scrollViewHeightConstraint.constant = selfHeight / 3
        self.layoutIfNeeded()
        
        // Add Images
//        self.addImages()
        
        // Set Title
//        self.label_Title.text = "TechCrunch Discrupt 2014"

        
        
        // Read & save json file
        self.dict_ProjectInfo = jsonToDict()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        println("scrollViewDidEndDecelerating")
        var offsetLooping = 1
        var page = (scrollView.contentOffset.x - selfWidth / CGFloat(2)) / selfWidth + CGFloat(offsetLooping)
        pageControl.currentPage = Int(page) % numberOfImages
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0)
        }
    }
    
    override func removeFromSuperview() {
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: .CurveEaseInOut, animations: {
            self.center = CGPointMake(self.center.x, self.selfHeight * 2)
            
            if let superView = self.superview as? UITableView {
                (superView.nextResponder() as! CJTableView2).btn_GoBack.alpha = 1.0
            }
            
        }) { (complete) -> Void in
            if let superView = self.superview as? UITableView {
                superView.scrollEnabled = true
                super.removeFromSuperview()
            }
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
                scrollView.frame.size.height
            )
            
            let imageView = UIImageView(frame: frame)
            println(imageView.frame)
            imageView.contentMode = .ScaleAspectFill
            imageView.image = UIImage(named: fileNames[i])!
            imageView.clipsToBounds = true
            scrollView.addSubview(imageView)
        }
        
        scrollView.contentSize = CGSizeMake(selfWidth * CGFloat(numberOfImages), selfHeight / 3);
        
        // Add PageControl
        pageControl = UIPageControl(frame: CGRectMake(0, scrollView.frame.size.height - 30, selfWidth, 20))
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
        println(path)
        if let data = NSData(contentsOfFile: path!, options: .DataReadingMappedIfSafe, error: nil) {
            var error: NSError?
            let json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &error) as! [String: AnyObject]
            return json
        }
        
        return [String: AnyObject]()
    }
    
    func addContents(title: String) {
        println(dict_ProjectInfo)
        self.dict_CurrentProject = dict_ProjectInfo[title] as! [String: AnyObject]
        label_Title.text = title
        
        // 1 - Images
        addImages(dict_CurrentProject["image"] as! [String])
        // 2 - URL
        self.urlString = dict_CurrentProject["url"] as! String
        // 3 - Description
        self.label_Description.text = dict_CurrentProject["description"] as? String
        // 4 - Details
        var string_Keys = ""
        var string_Values = ""
        for (key, value) in (dict_CurrentProject["details"] as! [String: String]) {
            string_Keys += "\(key)\n"
            string_Values += "\(value)\n"
        }
        self.label_Keys.text = string_Keys
        self.label_Values.text = string_Values
        
    }
    
}
