//
//  CJNavView1.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 4/15/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import UIKit

class CJNavView1: UINavigationController, UIViewControllerTransitioningDelegate {
    
    static let titleAttributes = [
        NSFontAttributeName : UIFont(name: "MyriadPro-Regular", size: 18)!
    ]
    static let titleAttributesDark = [
        NSFontAttributeName : UIFont(name: "MyriadPro-Regular", size: 18)!,
        NSForegroundColorAttributeName : UIColor.whiteColor()
    ]
    static let barItemAttributes = [
        NSFontAttributeName : UIFont(name: "MyriadPro-Light", size: 16)!
    ]
    
    class func applyNavigationBarStyle() {
        UINavigationBar.appearance().titleTextAttributes = CJNavView1.titleAttributes
        UIBarButtonItem.appearance().setTitleTextAttributes(CJNavView1.barItemAttributes, forState: .Normal)
    }
    
    class func applyNavigationBarStyleDark(vc: UIViewController?) {
        UINavigationBar.appearance().barStyle = .Black
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        if vc != nil {
            vc!.view.backgroundColor = UIColor.blackColor()
            vc!.navigationController!.navigationBar.barStyle = .Black
            vc!.navigationController!.navigationBar.tintColor = UIColor(red: 1, green: 211/255, blue: 0, alpha: 1)
            vc!.navigationController!.navigationBar.titleTextAttributes = CJNavView1.titleAttributesDark
        }
    }
    
    class func applyNavigationBarStyleLight(vc: UIViewController?) {
        UINavigationBar.appearance().barStyle = .Default
        UINavigationBar.appearance().tintColor = nil
        if vc != nil {
            vc!.view.backgroundColor = UIColor.whiteColor()
            vc!.navigationController!.navigationBar.barStyle = .Default
            vc!.navigationController!.navigationBar.tintColor = nil
            vc!.navigationController!.navigationBar.titleTextAttributes = CJNavView1.titleAttributes
        }
    }
    
    override func viewDidLoad() {
        setNavigationBarHidden(true, animated: false)
        CJNavView1.applyNavigationBarStyle()
        
    }
}
