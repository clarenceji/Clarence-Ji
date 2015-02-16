//
//  CJActivityIndicator.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 2/16/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import UIKit

class CJActivityIndicator: UIImageView {
    
    let imgView_Light = UIImageView()
    
    func startAnimate(parentVC: UIViewController) {
        image = UIImage(named: "ActivityIndicator_Ring")
        hidden = false
        bounds.size.width = 80
        bounds.size.height = 80
        center = parentVC.view.center
        
        let img_Light = UIImage(named: "ActivityIndicator_Ring")
        imgView_Light.frame = self.bounds
        imgView_Light.bounds.size.width = 60
        imgView_Light.bounds.size.height = 60
        imgView_Light.image = img_Light!
        insertSubview(imgView_Light, atIndex: 0)
        
        var animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = NSNumber(double: M_PI * 2)
        animation.duration = 5
        animation.repeatCount = 100
        
        parentVC.view.addSubview(self)
        layer.addAnimation(animation, forKey: "rotateAnimation")
        
        var animationR = CABasicAnimation(keyPath: "transform.rotation")
        animationR.toValue = NSNumber(double: -8 * M_PI)
        animationR.duration = 5
        animationR.repeatCount = 100
        imgView_Light.layer.addAnimation(animationR, forKey: "rotateAnimationReverse")
        
        alphaAnimation()
        
    }
    
    func stopAnimate() {
        imgView_Light.layer.removeAllAnimations()
        hidden = true
    }
    
    private func alphaAnimation() {
        UIView.animateWithDuration(1.8, delay: 1, options: nil, animations: {
            self.imgView_Light.alpha = 0.2
            
        }) { (Bool) -> Void in
            UIView.animateWithDuration(1.8, delay: 0.4, options: nil, animations: {
                self.imgView_Light.alpha = 1
            }, completion: { (Bool) -> Void in
                self.alphaAnimation()
            })
        }
    }
}
