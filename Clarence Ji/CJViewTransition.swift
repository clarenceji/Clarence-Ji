//
//  CJViewTransition.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 4/15/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import Foundation
import UIKit

class CJViewTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.8
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        var fromViewController: UIViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        var toViewController: UIViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        var sourceRect: CGRect = transitionContext.initialFrameForViewController(fromViewController)
        
        var containerView: UIView = transitionContext.containerView()
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
//        toViewController.view.alpha = 1.0
        toViewController.view.transform = CGAffineTransformMakeScale(0.8, 0.8)
        toViewController.view.center.x += UIScreen.mainScreen().bounds.width
        
        dispatch_async(dispatch_get_main_queue(), {
            UIView.animateWithDuration(0.8, animations: {
                
                fromViewController.view.transform = CGAffineTransformMakeScale(0.8, 0.8)
                fromViewController.view.center.x -= UIScreen.mainScreen().bounds.width
                
                
                UIView.animateWithDuration(0.8, animations: {
//                    toViewController.view.alpha = 1.0
                    toViewController.view.center.x -= UIScreen.mainScreen().bounds.width
                                        toViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    }, completion: nil)
                
                }, completion: {(finished: Bool) in
                    // transition completed
                    transitionContext.completeTransition(true)
                    fromViewController.view.removeFromSuperview()
            })
            
            
        })
        
        
    }
    
}