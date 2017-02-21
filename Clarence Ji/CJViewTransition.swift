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
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
//        var sourceRect: CGRect = transitionContext.initialFrameForViewController(fromViewController)
        
        let containerView: UIView = transitionContext.containerView
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        
        toViewController.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        toViewController.view.center.x += UIScreen.main.bounds.width
        
        DispatchQueue.main.async(execute: {
            UIView.animate(withDuration: 0.8, animations: {
                
                fromViewController.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                fromViewController.view.center.x -= UIScreen.main.bounds.width
                
                
                UIView.animate(withDuration: 0.8, animations: {
                    toViewController.view.center.x -= UIScreen.main.bounds.width
                                        toViewController.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }, completion: nil)
                
                }, completion: {(finished: Bool) in
                    // transition completed
                    transitionContext.completeTransition(true)
                    fromViewController.view.removeFromSuperview()
            })
            
            
        })
        
        
    }
    
}
