//
//  CJTableView1_Cell.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 4/15/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import UIKit

class CJTableView1_Cell: UITableViewCell, UIGestureRecognizerDelegate {
    
    @IBOutlet var view_BlackLayer: UIView!
    @IBOutlet var label_Title: UILabel!
    
    var prevTouchLocation: CGPoint!
    var index: Int!
    var tableView: CJTableView1!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view_BlackLayer.alpha = 0
        
        // Create shadow for label
        label_Title.layer.shadowColor = UIColor.blackColor().CGColor
        label_Title.layer.shadowRadius = 3.0
        label_Title.layer.shadowOpacity = 1.0
        label_Title.layer.shadowOffset = CGSizeMake(1, 2)
        
        self.selectionStyle = .None
        
        let recognizer_Tap = UITapGestureRecognizer(target: self, action: Selector("cellTapped:"))
        self.addGestureRecognizer(recognizer_Tap)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func animateBlackLayer() {
        dispatch_async(dispatch_get_main_queue(), {
            UIView.animateWithDuration(0.2, animations: {
                self.view_BlackLayer.alpha = 1
            })
        })
    }
    
    func hideBlackLayer() {
        dispatch_async(dispatch_get_main_queue(), {
            UIView.animateWithDuration(0.2, animations: {
                self.view_BlackLayer.alpha = 0
            })
        })
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        prevTouchLocation = (touches.first! as! UITouch).locationInView(self)
        animateBlackLayer()
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        hideBlackLayer()
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let currentTouchLocation = (touches.first! as! UITouch).locationInView(self)
        // Calculate touch displacement
        let displacementX = abs(currentTouchLocation.x - prevTouchLocation.x)
        let displacementY = abs(currentTouchLocation.y - prevTouchLocation.y)
        let displacement = sqrt(displacementX * displacementX + displacementY * displacementY)
        if displacement > 100 {
            hideBlackLayer()
        }
        
    }
    
    func cellTapped(recog_Tap: UITapGestureRecognizer) {
        println("cellTapped")
        if NSUserDefaults.standardUserDefaults().boolForKey("DarkMode") {
            tableView.view.backgroundColor = UIColor.blackColor()
        }
//        self.tableView.navigationController?.setNavigationBarHidden(false, animated: true)
//        for index in 0..<5 {
////            if index != self.index {
//                let cell = tableView.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0))
////                cell?.backgroundColor = UIColor.clearColor()
//                UIView.animateWithDuration(0.4, animations: {
//                    cell?.alpha = 0
//                })
////            }
//        }
        let detailView = self.tableView.storyboard!.instantiateViewControllerWithIdentifier("CJTableView2") as! CJTableView2
        detailView.headerCell(self)
        detailView.indexFromPrevView = index
        self.tableView.navigationController?.pushViewController(detailView, animated: true)
//        UIView.animateWithDuration(0.5, animations: {
//            self.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
//            self.separatorInset = UIEdgeInsetsMake(0, 1200, 0, 0)
//            self.alpha = 0
//        }) { (completed: Bool) -> Void in
////            let detailView = self.tableView.storyboard!.instantiateViewControllerWithIdentifier("CJTableView2") as! CJTableView2
////            detailView.setHeaderTableCell(self)
////            self.tableView.navigationController?.pushViewController(detailView, animated: true)
//            
//        }
    }

}
