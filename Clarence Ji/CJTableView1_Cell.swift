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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view_BlackLayer.alpha = 0
        
        // Create shadow for label
        label_Title.layer.shadowColor = UIColor.blackColor().CGColor
        label_Title.layer.shadowRadius = 3.0
        label_Title.layer.shadowOpacity = 1.0
        label_Title.layer.shadowOffset = CGSizeMake(1, 2)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func animateBlackLayer() {
        dispatch_async(dispatch_get_main_queue(), {
            UIView.animateWithDuration(0.3, animations: {
                self.view_BlackLayer.alpha = 1
            })
        })
    }
    
    func hideBlackLayer() {
        dispatch_async(dispatch_get_main_queue(), {
            UIView.animateWithDuration(0.3, animations: {
                self.view_BlackLayer.alpha = 0
            })
        })
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        animateBlackLayer()
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        hideBlackLayer()
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        hideBlackLayer()
    }

}
