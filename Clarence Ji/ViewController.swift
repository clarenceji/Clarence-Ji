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
        switch UIScreen.main.bounds.size.height {
        case 480:
            launchImageName = "LaunchImage-700@2x.png"
        case 568:
            launchImageName = "LaunchImage-700-568h@2x.png"
        case 667:
            launchImageName = "LaunchImage-800-667h@2x.png"
        case 736:
            launchImageName = "LaunchImage-800-Portrait-736h@3x.png"
        case 812:
            launchImageName = "SuperRetina_5.8.jpg"
        default:
            launchImageName = "LaunchImage"
        }
        imageView_Background.image = UIImage(named: launchImageName)
        
//        let currentDate = NSDate()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.hour, .minute], from:  Date())
        let currentHour = components.hour
        if currentHour! >= 18 || currentHour! <= 6 {
            UserDefaults.standard.set(true, forKey: "DarkMode")
        } else {
            UserDefaults.standard.set(false, forKey: "DarkMode")
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        CJAltimeter().getPressure { (success, reading) -> Void in
            if success {
                UserDefaults.standard.set(reading!, forKey: "AltimeterReading")
                UserDefaults.standard.set(true, forKey: "AltimeterReadingReady")
            }
            self.activityIndicator.stopAnimating()
            self.transitToNextView()
        }
        
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.transitionManager
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.transitionManager
    }
    
    func transitToNextView() {
        
        let nextView = self.storyboard!.instantiateViewController(withIdentifier: "CJNavView1") as! CJNavView1
        nextView.transitioningDelegate = self
        nextView.modalPresentationStyle = .custom
        self.present(nextView, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

}

