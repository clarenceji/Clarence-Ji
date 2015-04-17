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
    static let barItemAttributes = [
        NSFontAttributeName : UIFont(name: "MyriadPro-Light", size: 16)!
    ]
    
    class func applyNavigationBarStyle() {
        UINavigationBar.appearance().titleTextAttributes = CJNavView1.titleAttributes
        UIBarButtonItem.appearance().setTitleTextAttributes(CJNavView1.barItemAttributes, forState: .Normal)
    }
    
    class func applyNavigationBarStyleDark() {
        
    }
    
    override func viewDidLoad() {
        setNavigationBarHidden(true, animated: false)
        CJNavView1.applyNavigationBarStyle()
    }
}
