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
    
    var textViews = [IndexPath: UITextView]()
    
    var clickableCells = [IndexPath]()
    var renderedCells = [UITableViewCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.handleTxtFile()
        self.setUpHeader(self.headerCell)
        
        tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
        tableView.estimatedRowHeight = 10.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorStyle = .none
        
        if UserDefaults.standard.bool(forKey: "DarkMode") {
            CJNavView1.applyNavigationBarStyleDark(self)
            self.view_Header.backgroundColor = UIColor.black
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func headerCell(_ cell: UITableViewCell) {
        self.headerCell = cell
    }
    
    func setUpHeader(_ tableCell: UITableViewCell) {
        tableCell.frame.origin = CGPoint(x: 0, y: 0)
        self.view_Header.frame = tableCell.bounds
        self.view_Header.addSubview(tableCell)
        self.view_Header.isUserInteractionEnabled = false
    }
    
    let btn_GoBack = CJBackButton(frame: CGRect(x: 16, y: 28, width: 50, height: 20))
    override func viewWillAppear(_ animated: Bool) {
        setUpHeader(self.headerCell)
        
        btn_GoBack.addAction(self)
        self.navigationController?.view.insertSubview(btn_GoBack, belowSubview: self.navigationController!.navigationBar)
        
        navigationController!.setNavigationBarHidden(true, animated: true)
        self.title = (headerCell as! CJTableView1_Cell).label_Title.text
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        btn_GoBack.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset
        let imageHeight = self.headerCell.bounds.height
        
        if imageHeight - offset.y < 80 && navigationController?.isNavigationBarHidden == true {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        } else if imageHeight - offset.y >= 80 && navigationController?.isNavigationBarHidden == false {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let imageHeight = self.headerCell.bounds.height
        
        if imageHeight - offset.y >= 80 && navigationController?.isNavigationBarHidden == false {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return contentArray.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.setSelected(false, animated: true)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if renderedCells.count > indexPath.row {
            return renderedCells[indexPath.row]
        } else {
            switch self.contentArray[indexPath.row].0 {
            case true:
                // Bool is true - element in array is an image
                let cell = Bundle.main.loadNibNamed("CJTableView2_Cell", owner: self, options: nil)?[1] as! CJTableView2_ImageCell
                cell.selectionStyle = .none
                cell.isUserInteractionEnabled = false
                let newImage = self.contentArray[indexPath.row].1 as! UIImageView
                
                cell.image_View.addSubview(newImage)
                cell.image_View.frame = newImage.bounds
                
                if UserDefaults.standard.bool(forKey: "DarkMode") {
                    cell.backgroundColor = .black
                }
                
                renderedCells.append(cell)
                
                return cell
                
            case false:
                // Bool is false - element in array is not an image
                let cell = Bundle.main.loadNibNamed("CJTableView2_Cell", owner: self, options: nil)?[0] as! CJTableView2_Cell
                cell.selectionStyle = .none
                cell.isUserInteractionEnabled = false
                self.textViews[indexPath] = cell.label_Main
                // Configure the cell
                let attrString = self.contentArray[indexPath.row].1 as! NSMutableAttributedString
                if attrString.string[attrString.string.startIndex] == "∞" {
                    attrString.deleteCharacters(in: NSMakeRange(0, 1))
                    clickableCells.append(indexPath)
                }
                for iP in clickableCells {
                    if iP == indexPath {
                        cell.selectionStyle = .default
                        cell.accessoryType = .disclosureIndicator
                        cell.label_Main.isUserInteractionEnabled = false
                        cell.isUserInteractionEnabled = true
                    }
                }
                cell.label_Main.attributedText = attrString
                if UserDefaults.standard.bool(forKey: "DarkMode") {
                    cell.backgroundColor = .black
                    cell.label_Main.textColor = .white
                }
                
                renderedCells.append(cell)
                
                return cell
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CJTableView2_Cell
        cell.setSelected(false, animated: false)
        self.presentHoverView(cell.label_Main.text)
    }
    
    func handleTxtFile() {
        switch indexFromPrevView {
        case 0:
            let path = Bundle.main.path(forResource: "Text_Intro", ofType: "txt")
            generateAttrString(path)
            
            let imageView1 = CJImageView(image: UIImage(named: "Intro_1")!)
            self.contentArray.insert((true, imageView1), at: 1)
            
            let imageView2 = CJImageView(image: UIImage(named: "Intro_2")!)
            self.contentArray.insert((true, imageView2), at: 3)
            
        case 1:
            let path = Bundle.main.path(forResource: "Text_Education", ofType: "txt")
            generateAttrString(path)
            
            let imageView1 = CJImageView(image: UIImage(named: "Edu_1")!)
            self.contentArray.insert((true, imageView1), at: 2)
            
            let imageView2 = CJImageView(image: UIImage(named: "Edu_2")!)
            self.contentArray.insert((true, imageView2), at: 6)
            
        case 2:
            let path = Bundle.main.path(forResource: "Text_Hacker", ofType: "txt")
            generateAttrString(path)
            
        case 3:
            let path = Bundle.main.path(forResource: "Text_Life", ofType: "txt")
            generateAttrString(path)
            
        default:
            break
        }
    }
    
    func generateAttrString(_ path: String?) {
        do {
            let content = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            let array = content.components(separatedBy: "\n¶")
            let attrStyle = NSMutableParagraphStyle()
            attrStyle.lineSpacing = 8
            attrStyle.paragraphSpacing = 12
            
            for element in array {
                var string = element
                var attributes = [
                    NSAttributedStringKey.paragraphStyle: attrStyle,
                    NSAttributedStringKey.font: UIFont(name: "MyriadPro-Light", size: 17.0)!
                ]
                var attrString = NSMutableAttributedString(string: string, attributes: attributes)
                if string[string.startIndex] == "•" {
                    string.remove(at: string.startIndex)
                    attributes[NSAttributedStringKey.font] = UIFont(name: "MyriadPro-Regular", size: 17.0)!
                    
                    let newAttrStyle = attrStyle.mutableCopy() as! NSMutableParagraphStyle
                    newAttrStyle.paragraphSpacing = 3
                    newAttrStyle.lineSpacing = 0
                    attributes[NSAttributedStringKey.paragraphStyle] = newAttrStyle
                    
                    attrString = NSMutableAttributedString(string: string, attributes: attributes)
                }
                
                
                contentArray.append((false, attrString))
            }
            
        } catch _ {
        }
    }
    
    func textViewHeightForRowAtIndexPath(_ indexPath: IndexPath) -> CGFloat {
        var calculationView = textViews[indexPath]
        var textViewWidth = calculationView?.frame.size.width
        if calculationView?.attributedText != nil {
            calculationView = UITextView()
            calculationView!.attributedText = contentArray[indexPath.row].1 as! NSAttributedString
            textViewWidth = UIScreen.main.bounds.width
        }
        let size = calculationView!.sizeThatFits(CGSize(width: textViewWidth!, height: CGFloat(FLT_MAX)))
        return size.height
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if contentArray[indexPath.row].0 {
            return contentArray[indexPath.row].1.frame.height
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func presentHoverView(_ title: String) {
        let hoverView = Bundle.main.loadNibNamed("CJProjectDetailPopupView", owner: self, options: nil)?[0] as! CJProjectDetailPopupView
        hoverView.prevTableVC = self
        hoverView.addContents(title)
        self.navigationController!.view.addSubview(hoverView)
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.5, options: UIViewAnimationOptions(), animations: {
            self.navigationController!.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.navigationController!.view.layer.cornerRadius = 8.0
            self.navigationController!.view.clipsToBounds = true
            
            hoverView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
            self.btn_GoBack.alpha = 0
            }) { (complete) -> Void in
                self.tableView.isScrollEnabled = false
        }
    }


}
