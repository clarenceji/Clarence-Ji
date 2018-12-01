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
        NSAttributedStringKey.font : UIFont(name: "MyriadPro-Regular", size: 18)!
    ]
    static let titleAttributesDark = [
        NSAttributedStringKey.font : UIFont(name: "MyriadPro-Regular", size: 18)!,
        NSAttributedStringKey.foregroundColor : UIColor.white
    ]
    static let barItemAttributes = [
        NSAttributedStringKey.font : UIFont(name: "MyriadPro-Light", size: 16)!
    ]
    
    class func applyNavigationBarStyle() {
        UINavigationBar.appearance().titleTextAttributes = CJNavView1.titleAttributes
        UIBarButtonItem.appearance().setTitleTextAttributes(CJNavView1.barItemAttributes, for: UIControlState())
    }
    
    class func applyNavigationBarStyleDark(_ vc: UIViewController?) {
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().tintColor = UIColor.white
        if vc != nil {
            vc!.view.backgroundColor = UIColor.black
            vc!.navigationController!.navigationBar.barStyle = .black
            vc!.navigationController!.navigationBar.tintColor = UIColor(red: 1, green: 211/255, blue: 0, alpha: 1)
            vc!.navigationController!.navigationBar.titleTextAttributes = CJNavView1.titleAttributesDark
        }
    }
    
    class func applyNavigationBarStyleLight(_ vc: UIViewController?) {
        UINavigationBar.appearance().barStyle = .default
        UINavigationBar.appearance().tintColor = nil
        if vc != nil {
            vc!.view.backgroundColor = UIColor.white
            vc!.navigationController!.navigationBar.barStyle = .default
            vc!.navigationController!.navigationBar.tintColor = nil
            vc!.navigationController!.navigationBar.titleTextAttributes = CJNavView1.titleAttributes
        }
    }
    
    override func viewDidLoad() {
        setNavigationBarHidden(true, animated: false)
        CJNavView1.applyNavigationBarStyle()
        
    }
}
