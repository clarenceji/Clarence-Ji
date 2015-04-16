//
//  ViewController.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 2/16/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var imageView_Background: UIImageView!
    
    let transitionManager = CJViewTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load Launch Image on First View
        var launchImageName = ""
        switch UIScreen.mainScreen().bounds.size.height {
        case 480:
            launchImageName = "LaunchImage-700@2x.png"
        case 568:
            launchImageName = "LaunchImage-700-568h@2x.png"
        case 667:
            launchImageName = "LaunchImage-800-667h@2x.png"
        case 736:
            launchImageName = "LaunchImage-800-Portrait-736h@3x.png"
        default:
            launchImageName = "LaunchImage"
        }
        imageView_Background.image = UIImage(named: launchImageName)
        
    }

    override func viewDidAppear(animated: Bool) {
        CJAltimeter().getPressure { (success, reading) -> Void in
            if success {
                NSUserDefaults.standardUserDefaults().setFloat(reading!, forKey: "AltimeterReading")
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "AltimeterReadingReady")
            }
            self.activityIndicator.stopAnimating()
            self.transitToNextView()
        }
        
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.transitionManager
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.transitionManager
    }
    
    func transitToNextView() {
        
        let nextView = self.storyboard!.instantiateViewControllerWithIdentifier("CJNavView1") as! CJNavView1
        nextView.transitioningDelegate = self
        nextView.modalPresentationStyle = .Custom
        self.presentViewController(nextView, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

}

