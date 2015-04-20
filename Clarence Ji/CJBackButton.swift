//
//  CJBackButton.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 4/19/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import UIKit

class CJBackButton: UIButton, UIGestureRecognizerDelegate {
    
    var sourceView: UIViewController!
    
    override init(frame: CGRect) {
        super.init(frame: CGRectMake(frame.origin.x, frame.origin.y, 30, 30))
        self.setImage(UIImage(named: "BackButton"), forState: .Normal)
        
        var blurEffect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.bounds
        blurView.layer.cornerRadius = self.bounds.width / 2
        blurView.clipsToBounds = true
        blurView.userInteractionEnabled = true
        self.insertSubview(blurView, belowSubview: imageView!)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAction(source: UIViewController) {
        self.sourceView = source
        
        let recog_Tap = UITapGestureRecognizer()
        recog_Tap.delegate = self
        recog_Tap.addTarget(self, action: Selector("buttonPressed:"))
        self.addGestureRecognizer(recog_Tap)
    }
    
    func buttonPressed(recog: UITapGestureRecognizer) {
        self.sourceView.navigationController?.popViewControllerAnimated(true)
    }
    
//    override func addTarget(target: AnyObject?, action: Selector, forControlEvents controlEvents: UIControlEvents) {
//        super.addTarget(target, action: action, forControlEvents: controlEvents)
//    }
}
