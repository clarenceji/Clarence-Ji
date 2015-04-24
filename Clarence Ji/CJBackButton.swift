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
    
    var blackLayer = UIView()
    
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
        
        blackLayer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        blackLayer.frame = self.bounds
        blackLayer.layer.cornerRadius = self.bounds.width / 2
        blackLayer.clipsToBounds = true
        blackLayer.alpha = 0
        self.insertSubview(blackLayer, belowSubview: self.imageView!)
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
    
    
    var prevTouchLocation: CGPoint!
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        prevTouchLocation = (touches.first! as! UITouch).locationInView(self)
        UIView.animateWithDuration(0.2, animations: {
            self.blackLayer.alpha = 1.0
        })
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        let currentTouchLocation = (touches.first! as! UITouch).locationInView(self)
        // Calculate touch displacement
        let displacementX = abs(currentTouchLocation.x - prevTouchLocation.x)
        let displacementY = abs(currentTouchLocation.y - prevTouchLocation.y)
        let displacement = sqrt(displacementX * displacementX + displacementY * displacementY)
        if displacement > 30 {
            UIView.animateWithDuration(0.2, animations: {
                self.blackLayer.alpha = 0.0
            })
        }
    }
    
}
