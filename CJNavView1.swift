//
//  CJNavView1.swift
//  Clarence Ji
//
//  Created by Clarence Ji on 4/15/15.
//  Copyright (c) 2015 Clarence Ji. All rights reserved.
//

import UIKit

class CJNavView1: UINavigationController, UIViewControllerTransitioningDelegate {
    override func viewDidLoad() {
        setNavigationBarHidden(true, animated: false)
        
        let titleAttributes = [
            NSFontAttributeName : UIFont(name: "MyriadPro-Regular", size: 18)!
        ]
        let barItemAttributes = [
            NSFontAttributeName : UIFont(name: "MyriadPro-Light", size: 16)!
        ]
        UINavigationBar.appearance().titleTextAttributes = titleAttributes
        UIBarButtonItem.appearance().setTitleTextAttributes(barItemAttributes, forState: .Normal)
    }
}
