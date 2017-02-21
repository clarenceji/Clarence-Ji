//
//  CJProjectDetailPopupView.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 4/21/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import UIKit

class CJProjectDetailPopupView: UIView, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
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
    
    let screen = UIScreen.main.bounds
    let selfWidth = UIScreen.main.bounds.width
    let selfHeight = UIScreen.main.bounds.height
    var numberOfImages = 3
    var pageControl: UIPageControl!
    
    let darkMode = UserDefaults.standard.bool(forKey: "DarkMode")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        // screen.height + selfHeight: Prepare for animation
        let selfFrame = CGRect(x: 0, y: screen.height + selfHeight, width: selfWidth, height: selfHeight)
        self.frame = selfFrame
        
        // Blur View
        var blurEffect = UIBlurEffect(style: .dark)
        if darkMode {
            blurEffect = UIBlurEffect(style: .light)
        }
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.bounds
        self.backgroundColor = .clear
        self.addSubview(blurView)
        self.sendSubview(toBack: blurView)
        
        // Add buttons
        self.addButtons()
        
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
        
        self.scrollView_Images.delegate = self
        self.scrollView_Images.isPagingEnabled = true
        // Image takes up 1/3 of whole view
        self.scrollViewHeightConstraint.constant = selfHeight / 3
        self.layoutIfNeeded()
        
        self.tableView_Details.delegate = self
        self.tableView_Details.dataSource = self
        self.tableView_Details.estimatedRowHeight = 35.0
        self.tableView_Details.rowHeight = UITableViewAutomaticDimension
        
        
        // Read & save json file
        self.dict_ProjectInfo = jsonToDict()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView_Images {
            let offsetLooping = 1
            let page = (scrollView.contentOffset.x - selfWidth / CGFloat(2)) / selfWidth + CGFloat(offsetLooping)
            pageControl.currentPage = Int(page) % numberOfImages
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView_Images.contentOffset.y != 0 {
            scrollView_Images.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 0)
        }
    }
    
    override func removeFromSuperview() {
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: UIViewAnimationOptions(), animations: {
            self.center = CGPoint(x: self.center.x, y: self.selfHeight * 2)
            self.prevTableVC.btn_GoBack.alpha = 1.0
            self.alpha = 0
            self.superview!.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.superview!.layer.cornerRadius = 0
        }) { (complete) -> Void in
            self.prevTableVC.tableView.isScrollEnabled = true
            super.removeFromSuperview()
        }
    }
    
    func addImages(_ fileNames: [String]) {
        self.numberOfImages = fileNames.count
        
        // Populate ScrollView with Images
        for i in 0 ..< numberOfImages {
            let frame = CGRect(
                x: self.frame.size.width * CGFloat(i),
                y: 0,
                width: self.frame.size.width,
                height: scrollView_Images.frame.size.height
            )
            
            let imageView = UIImageView(frame: frame)
            imageView.contentMode = .scaleAspectFill
            imageView.image = UIImage(named: fileNames[i])!
            imageView.clipsToBounds = true
            scrollView_Images.addSubview(imageView)
        }
        
        scrollView_Images.contentSize = CGSize(width: selfWidth * CGFloat(numberOfImages), height: selfHeight / 3);
        
        // Add PageControl
        pageControl = UIPageControl(frame: CGRect(x: 0, y: scrollView_Images.frame.size.height + scrollView_Images.frame.origin.y - 20, width: selfWidth, height: 20))
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
        btn_Details = UIButton(frame: CGRect(x: 0, y: selfHeight - 44, width: selfWidth / 2, height: 44))
        btn_Details.setTitle("More Details", for: UIControlState())
        btn_Details.titleLabel?.font = font_Reg
        btn_Details.backgroundColor = bgColor
        btn_Details.addTarget(self, action: #selector(CJProjectDetailPopupView.btn_Details_Pressed(_:)), for: .touchUpInside)
        btn_Done = UIButton(frame: CGRect(x: selfWidth / 2, y: selfHeight - 44, width: selfWidth / 2, height: 44))
        btn_Done.setTitle("Done", for: UIControlState())
        btn_Done.titleLabel?.font = font_Light
        btn_Done.backgroundColor = bgColor
        btn_Done.addTarget(self, action: #selector(CJProjectDetailPopupView.btn_Done_Pressed(_:)), for: .touchUpInside)
        self.addSubview(btn_Details)
        self.addSubview(btn_Done)
    }
    
    func btn_Done_Pressed(_ sender: AnyObject) {
        removeFromSuperview()
    }
    
    func btn_Details_Pressed(_ sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: self.urlString)!)
    }
    
    func jsonToDict() -> [String: AnyObject] {
        let path = Bundle.main.path(forResource: "Project_Info", ofType: "json")
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
//            var error: NSError?
            let json = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: AnyObject]
            return json
        } catch _ {
        }
        
        return [String: AnyObject]()
    }
    
    func addContents(_ title: String) {
        self.dict_CurrentProject = dict_ProjectInfo[title] as? [String: AnyObject]
        label_Title.text = title
        
        if let currentDict = self.dict_CurrentProject {
            // 1 - Images
            addImages(currentDict["image"] as! [String])
            // 2 - URL
            var urlStringFromDict = currentDict["url"] as! String
            if urlStringFromDict[urlStringFromDict.startIndex] == "•" {
                urlStringFromDict.remove(at: urlStringFromDict.startIndex)
                btn_Details.setImage(UIImage(named: "Troll-face"), for: UIControlState())
                btn_Details.imageView?.contentMode = .scaleAspectFit
            }
            self.urlString = urlStringFromDict
            // 3 - Description
            let string = currentDict["description"] as? String
            let attrStyle = NSMutableParagraphStyle()
            attrStyle.lineSpacing = 7
            let attributes = [
                NSParagraphStyleAttributeName: attrStyle
            ]
            let attrString = NSMutableAttributedString(string: string!, attributes: attributes)
            self.label_Description.attributedText = attrString
            self.label_Description.textAlignment = .center
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if array_Keys != nil {
            return array_Keys!.count
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CJProjectDetailPopupView", owner: self, options: nil)?[1] as! CJProjectDetailPopupView_Cell
        cell.selectionStyle = .none
        
        let attrStyle = NSMutableParagraphStyle()
        attrStyle.lineSpacing = 7
        let attributes = [
            NSParagraphStyleAttributeName: attrStyle
        ]
        
        if array_Keys != nil && array_Values != nil {
            let attrString_Key = NSMutableAttributedString(string: array_Keys![indexPath.row], attributes: attributes)
            let attrString_Value = NSMutableAttributedString(string: array_Values![indexPath.row], attributes: attributes)
            
            cell.label_Key.attributedText = attrString_Key
            cell.label_Value.attributedText = attrString_Value
            
            cell.label_Key.textAlignment = .right
            
            cell.label_Key_ConstraintWidth.constant = self.frame.size.width * 0.32
            cell.layoutIfNeeded()
        }
        
        return cell
    }
    
}
